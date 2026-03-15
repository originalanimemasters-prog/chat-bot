from openai import OpenAI
from dotenv import load_dotenv
import os

from vector_memory import store_memory, retrieve_memory

load_dotenv()

client = OpenAI(
    api_key=os.getenv("GROQ_API_KEY"),
    base_url="https://api.groq.com/openai/v1"
)


def generate_response(prompt, chat_id):

    # retrieve relevant memories
    memories = retrieve_memory(prompt, chat_id)

    full_prompt = f"""
You are an intelligent assistant.

Relevant past memories:
{memories}

User question:
{prompt}

Use the memories if they are helpful.
"""

    completion = client.chat.completions.create(
        model="llama-3.1-8b-instant",
        messages=[
            {"role": "user", "content": full_prompt}
        ]
    )

    response = completion.choices[0].message.content

    # store conversation memory
    store_memory(prompt, chat_id)
    store_memory(response, chat_id)

    return response