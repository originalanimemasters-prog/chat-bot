from fastapi import FastAPI
from models import ChatRequest
from ai_engine import generate_response
from memory import save_message, get_chat_history
from database import conn

app = FastAPI()


@app.post("/new_chat")
def new_chat():

    cursor = conn.execute(
        "INSERT INTO chats (title) VALUES ('New Chat')"
    )

    conn.commit()

    chat_id = cursor.lastrowid

    return {"chat_id": chat_id}


@app.post("/chat")
def chat(req: ChatRequest):

    history = get_chat_history(req.chat_id)

    prompt = ""

    for role, text in history:
        prompt += f"{role}: {text}\n"

    prompt += f"user: {req.message}"

    reply = generate_response(prompt)

    save_message(req.chat_id, "user", req.message)
    save_message(req.chat_id, "assistant", reply)

    return {"reply": reply}