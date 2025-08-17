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
    # TODO: replace with real provider routing (OpenAI, DeepSeek, Anthropic, Kimi, AiMax API)
    return {"provider": req.provider, "output": f"echo: {req.prompt}"}
