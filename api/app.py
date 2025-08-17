from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(title="AiMax API")

# Allow the Vite dev server and localhost to call the API
origins = [
    "http://localhost:5173",
    "http://127.0.0.1:5173",
    "http://localhost:3000",
    "http://127.0.0.1:3000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


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
