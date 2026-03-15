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


@app.get("/chats")
def get_chats():

    cursor = conn.execute(
        "SELECT id, title FROM chats"
    )

    chats = []

    for row in cursor:
        chats.append({
            "id": row[0],
            "title": row[1]
        })

    return chats


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


# NEW API
@app.get("/messages/{chat_id}")
def get_messages(chat_id: int):

    cursor = conn.execute(
        "SELECT role, content FROM messages WHERE chat_id=?",
        (chat_id,)
    )

    messages = []

    for row in cursor:
        messages.append({
            "role": row[0],
            "text": row[1]
        })

    return messages
@app.put("/rename_chat/{chat_id}")
def rename_chat(chat_id: int, title: str):

    conn.execute(
        "UPDATE chats SET title=? WHERE id=?",
        (title, chat_id)
    )

    conn.commit()

    return {"status": "ok"}


@app.delete("/delete_chat/{chat_id}")
def delete_chat(chat_id: int):

    conn.execute(
        "DELETE FROM messages WHERE chat_id=?",
        (chat_id,)
    )

    conn.execute(
        "DELETE FROM chats WHERE id=?",
        (chat_id,)
    )

    conn.commit()

    return {"status": "deleted"}