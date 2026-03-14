import sqlite3

conn = sqlite3.connect("chat.db", check_same_thread=False)

cursor = conn.cursor()

cursor.execute("""
CREATE TABLE IF NOT EXISTS chats(
id INTEGER PRIMARY KEY AUTOINCREMENT,
title TEXT
)
""")

cursor.execute("""
CREATE TABLE IF NOT EXISTS messages(
id INTEGER PRIMARY KEY AUTOINCREMENT,
chat_id INTEGER,
role TEXT,
content TEXT
)
""")

conn.commit()