# AiMax OS

**AiMax OS Light** – un sistem de operare open-source pentru developeri AI.

## 📦 Structură
- `api/` → FastAPI backend (endpoints /chat, /health)
- `cli/` → CLI tool (`ai chat "prompt"`)
- `ui/` → React/Vite frontend
- `firstboot/` → Wizard pentru configurare inițială
- `systemd/` → unit files pentru auto-start
- `bootstrap.sh` → script pentru Cubic (ISO custom)

## 🚀 Rulare locală (dev)
```bash
docker compose up
```
API → http://localhost:8000  
UI → http://localhost:5173

## 🔑 CLI usage
```bash
cd cli
python3 ai.py chat "Scrie un haiku despre AI"
```

## 📀 Creare ISO AiMax OS Light
- Rulează `bootstrap.sh` în Cubic (chroot)
- Generează `aimax-os-light.iso`
- Scrie ISO pe stick cu Rufus
