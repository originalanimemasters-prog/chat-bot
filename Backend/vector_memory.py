import chromadb
from sentence_transformers import SentenceTransformer

# embedding model
model = SentenceTransformer("all-MiniLM-L6-v2")

# vector database
client = chromadb.Client()

collection = client.get_or_create_collection(
    name="chat_memory"
)


def store_memory(text, chat_id):

    embedding = model.encode(text).tolist()

    collection.add(
        documents=[text],
        embeddings=[embedding],
        metadatas=[{"chat_id": chat_id}],
        ids=[f"{chat_id}_{hash(text)}"]
    )


def retrieve_memory(query, chat_id, top_k=3):

    embedding = model.encode(query).tolist()

    results = collection.query(
        query_embeddings=[embedding],
        n_results=top_k,
        where={"chat_id": chat_id}
    )

    if not results["documents"]:
        return ""

    memory_text = ""

    for doc in results["documents"][0]:
        memory_text += doc + "\n"

    return memory_text