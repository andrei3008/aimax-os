#!/usr/bin/env python3
import os, typer, requests

app = typer.Typer(help="AiMax unified CLI")
API = os.environ.get("AIMAX_API", "http://127.0.0.1:8000")

@app.command()
def chat(prompt: str, provider: str = "openai"):
    """Send a quick chat prompt to the local AiMax API."""
    r = requests.post(f"{API}/chat", json={"provider": provider, "prompt": prompt})
    r.raise_for_status()
    print(r.json()["output"])

if __name__ == "__main__":
    app()
