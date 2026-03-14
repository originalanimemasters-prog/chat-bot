from database import conn

def save_message(chat_id, role, content):

    conn.execute(
        "INSERT INTO messages (chat_id, role, content) VALUES (?, ?, ?)",
        (chat_id, role, content)
    )

    conn.commit()


def get_chat_history(chat_id):

    cursor = conn.execute(
        "SELECT role, content FROM messages WHERE chat_id=?",
        (chat_id,)
    )

    return cursor.fetchall()