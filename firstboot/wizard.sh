#!/usr/bin/env bash
set -euo pipefail
CFG="$HOME/.config/aimax"
mkdir -p "$CFG"

if [ -f "$CFG/.done" ]; then
  echo "AiMax OS deja configurat."
  exit 0
fi

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
echo "Configurare salvată în $CFG/config.json"
