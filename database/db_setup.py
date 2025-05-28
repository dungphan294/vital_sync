import sqlite3
import os

class Database:
    def __init__(self, db_path):
        self.db_path = db_path

    def create_db(self):
        # Explicitly create the database file if it doesn't exist
        if not os.path.exists(self.db_path):
            with sqlite3.connect(self.db_path):
                pass  # Just create the file

    def connect(self):
        return sqlite3.connect(self.db_path)

    def create_table(self, table_name, columns):
        columns_def = ', '.join([f"{col} {ctype}" for col, ctype in columns.items()])
        query = f"CREATE TABLE IF NOT EXISTS {table_name} ({columns_def});"
        with self.connect() as conn:
            cursor = conn.cursor()
            cursor.execute(query)
            conn.commit()

# Example usage:
if __name__ == "__main__":
    db = Database("example.db")
    db.create_db()  # Explicitly create the database file
    db.create_table(
        "users",
        {
            "id": "INTEGER PRIMARY KEY AUTOINCREMENT",
            "username": "TEXT NOT NULL",
            "email": "TEXT",
            "created_at": "TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        }
    )