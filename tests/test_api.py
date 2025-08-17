import requests


BASE = "http://localhost:8000"


def test_health():
    r = requests.get(f"{BASE}/health", timeout=5)
    assert r.status_code == 200
    assert r.json().get("ok") is True


def test_chat_echo():
    payload = {"prompt": "test message", "provider": "openai"}
    r = requests.post(f"{BASE}/chat", json=payload, timeout=5)
    assert r.status_code == 200
    data = r.json()
    assert data.get("provider") == "openai"
    assert data.get("output") == "echo: test message"
