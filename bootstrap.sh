#!/usr/bin/env bash
set -euo pipefail

echo "[*] Update & upgrade"
apt-get update && apt-get upgrade -y

echo "[*] Instalare XFCE Light + login manager"
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xfce4 xfce4-goodies lightdm network-manager

echo "[*] Tool-uri dezvoltare AI"
apt-get install -y \
    git curl wget unzip zip make build-essential pkg-config \
    python3 python3-venv python3-pip python3-dev \
    nodejs npm \
    docker.io docker-compose \
    redis postgresql postgresql-contrib \
    htop tmux fzf ripgrep jq yq

# VS Code (snap)
snap install code --classic || true

# Ollama (modele AI locale)
curl -fsSL https://ollama.com/install.sh | sh || true

echo "[*] Creez user dev"
id -u dev &>/dev/null || useradd -m -s /bin/bash dev
usermod -aG docker dev

echo "[*] Branding AiMax OS"
cat > /etc/os-release <<'EOF'
NAME="AiMax OS Light"
PRETTY_NAME="AiMax OS Light 24.04"
ID=aimax
HOME_URL="https://aimax.ro"
SUPPORT_URL="https://os.aimax.ro"
EOF

# GRUB branding
sed -i 's/^GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="AiMax OS"/' /etc/default/grub || true

# Wallpaper default (placeholder)
mkdir -p /usr/share/backgrounds/aimax
echo "AiMax OS Wallpaper" > /usr/share/backgrounds/aimax/default.png

echo "[*] Creez structura /opt/aimax"
mkdir -p /opt/aimax/{api,cli,ui,firstboot}
chown -R dev:dev /opt/aimax

echo "[*] API skeleton (FastAPI)"
cat > /opt/aimax/api/app.py <<'PY'
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="AiMax API")

class ChatReq(BaseModel):
    provider: str = "openai"
    prompt: str

@app.get("/health")
def health():
    return {"ok": True}

@app.post("/chat")
def chat(req: ChatReq):
    return {"provider": req.provider, "output": f"echo: {req.prompt}"}
PY

python3 -m venv /opt/aimax/api/.venv
/opt/aimax/api/.venv/bin/pip install fastapi uvicorn[standard] pydantic

echo "[*] CLI skeleton (Typer)"
cat > /opt/aimax/cli/ai.py <<'PY'
#!/usr/bin/env python3
import os, typer, requests

app = typer.Typer(help="AiMax unified CLI")
API = os.environ.get("AIMAX_API", "http://127.0.0.1:8000")

@app.command()
def chat(prompt: str, provider: str = "openai"):
    r = requests.post(f"{API}/chat", json={"provider": provider, "prompt": prompt})
    r.raise_for_status()
    print(r.json()["output"])

if __name__ == "__main__":
    app()
PY

chmod +x /opt/aimax/cli/ai.py
ln -sf /opt/aimax/cli/ai.py /usr/local/bin/ai
python3 -m pip install typer requests

echo "[*] First-boot wizard"
cat > /opt/aimax/firstboot/wizard.sh <<'SH'
#!/usr/bin/env bash
set -euo pipefail
CFG="/home/dev/.config/aimax"
mkdir -p "$CFG"
if [ -f "$CFG/.done" ]; then exit 0; fi
echo "=== AiMax OS Setup ==="
read -p "Provider implicit (openai/deepseek/anthropic/kimi/aimax): " prov
read -p "API key (sau lasă gol): " key
cat <<EOF > "$CFG/config.json"
{
  "provider": "$prov",
  "api_key": "$key"
}
EOF
touch "$CFG/.done"
SH
chmod +x /opt/aimax/firstboot/wizard.sh

echo "[*] Systemd services"
cat > /etc/systemd/system/aimax-api.service <<'UNIT'
[Unit]
Description=AiMax API (FastAPI)
After=network-online.target
Wants=network-online.target
[Service]
Type=simple
User=dev
WorkingDirectory=/opt/aimax/api
ExecStart=/opt/aimax/api/.venv/bin/uvicorn app:app --host 0.0.0.0 --port 8000
Restart=always
[Install]
WantedBy=multi-user.target
UNIT

cat > /etc/systemd/system/aimax-firstboot.service <<'UNIT'
[Unit]
Description=AiMax OS First Boot Wizard
After=graphical.target
[Service]
Type=oneshot
User=dev
Environment=HOME=/home/dev
ExecStart=/opt/aimax/firstboot/wizard.sh
[Install]
WantedBy=graphical.target
UNIT

systemctl enable aimax-api.service aimax-firstboot.service

echo "[*] Shortcut pentru Dashboard"
cat > /usr/share/applications/aimax.desktop <<'DESK'
[Desktop Entry]
Type=Application
Name=AiMax Dashboard
Exec=xdg-open http://localhost:5173
Icon=utilities-terminal
Terminal=false
Categories=Development;
DESK

echo "[*] Curățare"
apt-get clean
