from fastapi import FastAPI
from models import ChatRequest, ChatResponse
from ai_engine import generate_response
from tools.search import search_web

app = FastAPI()

@app.post("/chat", response_model=ChatResponse)
def chat(req: ChatRequest):

    user_message = req.message.lower()

    try:

        if "search" in user_message or "news" in user_message or "latest" in user_message:

            web_data = search_web(user_message)

            prompt = f"""
User question: {user_message}

Internet results:
{web_data}

Give a helpful answer.
"""

            reply = generate_response(prompt)

        else:

            reply = generate_response(user_message)

        return ChatResponse(reply=reply)

    except Exception as e:

        print("ERROR:", e)

        return ChatResponse(reply="AI error occurred.")