import os
from typing import Any

import httpx
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from fastapi.responses import Response
from pydantic import BaseModel, Field

load_dotenv()
app = FastAPI(title="WildQuest AI/Voice Gateway", version="1.0.0")

GEMMA_ENDPOINT = os.getenv("GEMMA_ENDPOINT", "").strip()
GEMMA_API_KEY = os.getenv("GEMMA_API_KEY", "").strip()
GEMMA_MODEL = os.getenv("GEMMA_MODEL", "gemma-3-1b-it").strip()
ELEVENLABS_API_KEY = os.getenv("ELEVENLABS_API_KEY", "").strip()
ELEVENLABS_VOICE_ID = os.getenv("ELEVENLABS_VOICE_ID", "EXAVITQu4vr4xnSDxMaL").strip()

class QuestRequest(BaseModel):
    system: str = Field(min_length=1, max_length=8000)
    prompt: str = Field(min_length=1, max_length=12000)
    model: str | None = None

class VoiceRequest(BaseModel):
    text: str = Field(min_length=1, max_length=1000)
    cache_key: str | None = Field(default=None, max_length=120)

@app.get("/health")
async def health() -> dict[str, Any]:
    return {"ok": True, "gemma_configured": bool(GEMMA_ENDPOINT), "voice_configured": bool(ELEVENLABS_API_KEY)}

@app.post("/api/ai/quest")
async def ai_quest(body: QuestRequest) -> dict[str, str]:
    if not GEMMA_ENDPOINT:
        raise HTTPException(status_code=503, detail="GEMMA_ENDPOINT is not configured")
    headers = {"Content-Type": "application/json"}
    if GEMMA_API_KEY:
        headers["Authorization"] = f"Bearer {GEMMA_API_KEY}"
    payload = {
        "model": body.model or GEMMA_MODEL,
        "messages": [
            {"role": "system", "content": body.system},
            {"role": "user", "content": body.prompt},
        ],
        "temperature": 0.8,
        "max_tokens": 512,
    }
    async with httpx.AsyncClient(timeout=30) as client:
        r = await client.post(GEMMA_ENDPOINT, headers=headers, json=payload)
    if r.status_code < 200 or r.status_code >= 300:
        raise HTTPException(status_code=502, detail=f"Gemma endpoint returned {r.status_code}")
    data = r.json()
    content = None
    choices = data.get("choices") if isinstance(data, dict) else None
    if isinstance(choices, list) and choices:
        first = choices[0]
        if isinstance(first, dict):
            message = first.get("message")
            if isinstance(message, dict):
                content = message.get("content")
            if not content:
                content = first.get("text")
    if not content and isinstance(data, dict):
        content = data.get("response") or data.get("output")
    if not isinstance(content, str) or not content.strip():
        raise HTTPException(status_code=502, detail="Gemma response had no text content")
    return {"content": content}

@app.post("/api/voice")
async def voice(body: VoiceRequest) -> Response:
    if not ELEVENLABS_API_KEY:
        raise HTTPException(status_code=503, detail="ELEVENLABS_API_KEY is not configured")
    if not ELEVENLABS_VOICE_ID:
        raise HTTPException(status_code=503, detail="ELEVENLABS_VOICE_ID is not configured")
    url = f"https://api.elevenlabs.io/v1/text-to-speech/{ELEVENLABS_VOICE_ID}"
    payload = {
        "text": body.text,
        "model_id": "eleven_turbo_v2",
        "voice_settings": {"stability": 0.5, "similarity_boost": 0.75},
    }
    headers = {"xi-api-key": ELEVENLABS_API_KEY, "Content-Type": "application/json", "Accept": "audio/mpeg"}
    async with httpx.AsyncClient(timeout=30) as client:
        r = await client.post(url, headers=headers, json=payload)
    if r.status_code < 200 or r.status_code >= 300:
        raise HTTPException(status_code=502, detail=f"ElevenLabs returned {r.status_code}")
    return Response(content=r.content, media_type="audio/mpeg")
