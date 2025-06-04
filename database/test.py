import sqlite3
import datetime

DB_PATH = "example.db"

def convert_timestamp(value):
    return datetime.datetime.strptime(value.decode("utf-8"), "%Y-%m-%d %H:%M:%S")

sqlite3.register_converter("TIMESTAMP", convert_timestamp)

def get_connection(db_path=DB_PATH):
    return sqlite3.connect(db_path, detect_types=sqlite3.PARSE_DECLTYPES)

def create_tables(cursor):
    cursor.executescript("""
    CREATE TABLE IF NOT EXISTS "user" (
        "user_id" TEXT PRIMARY KEY,
        "username" TEXT NOT NULL,
        "password" TEXT NOT NULL,
        "name" TEXT,
        "email" TEXT UNIQUE,
        "dob" DATE,
        "created_time" TIMESTAMP NOT NULL,
        "updated_time" TIMESTAMP
    );
    CREATE TABLE IF NOT EXISTS "device" (
        "device_id" TEXT PRIMARY KEY,
        "serial_number" TEXT UNIQUE,
        "model" TEXT,
        "created_time" TIMESTAMP NOT NULL,
        "updated_time" TIMESTAMP
    );
    CREATE TABLE IF NOT EXISTS "phone" (
        "phone_id" TEXT PRIMARY KEY,
        "model" TEXT,
        "os" TEXT,
        "serial_number" TEXT,
        "created_time" TIMESTAMP NOT NULL,
        "updated_time" TIMESTAMP
    );
    CREATE TABLE IF NOT EXISTS "workout" (
        "workout_id" TEXT PRIMARY KEY,
        "start_time" TIMESTAMP,
        "end_time" TIMESTAMP,
        "type" TEXT
    );
    CREATE TABLE IF NOT EXISTS "data" (
        "timestamp" TIMESTAMP NOT NULL,
        "user_id" TEXT NOT NULL,
        "phone_id" TEXT NOT NULL,
        "device_id" TEXT NOT NULL,
        "workout_id" TEXT,
        "heart_rate" INTEGER,
        "oxygen_saturation" INTEGER,
        "step_counts" INTEGER,
        PRIMARY KEY("timestamp", "user_id", "phone_id", "device_id"),
        FOREIGN KEY ("user_id") REFERENCES "user"("user_id"),
        FOREIGN KEY ("phone_id") REFERENCES "phone"("phone_id"),
        FOREIGN KEY ("workout_id") REFERENCES "workout"("workout_id"),
        FOREIGN KEY ("device_id") REFERENCES "device"("device_id")
    );
    """)

def insert_sample_users(cursor):
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    sample_users = [
        ("u001", "alice", "pass123", "Alice Smith", "alice@example.com", "1990-01-01", now, None),
        ("u002", "bob", "pass456", "Bob Johnson", "bob@example.com", "1985-05-12", now, None),
        ("u003", "carol", "pass789", "Carol Lee", "carol@example.com", "1992-07-23", now, None),
        ("u004", "dave", "pass321", "Dave Kim", "dave@example.com", "1988-03-15", now, None),
        ("u005", "eve", "pass654", "Eve Miller", "eve@example.com", "1995-11-30", now, None),
        ("u006", "frank", "pass987", "Frank Brown", "frank@example.com", "1983-09-09", now, None),
        ("u007", "grace", "passabc", "Grace Wilson", "grace@example.com", "1991-12-19", now, None),
        ("u008", "heidi", "passdef", "Heidi Clark", "heidi@example.com", "1987-06-05", now, None),
        ("u009", "ivan", "passghi", "Ivan Lewis", "ivan@example.com", "1993-04-27", now, None),
        ("u010", "judy", "passjkl", "Judy Walker", "judy@example.com", "1996-08-14", now, None),
    ]
    cursor.executemany("""
    INSERT OR IGNORE INTO "user" (
        user_id, username, password, name, email, dob, created_time, updated_time
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """, sample_users)

def main():
    with get_connection() as conn:
        cursor = conn.cursor()
        create_tables(cursor)
        insert_sample_users(cursor)
        conn.commit()

if __name__ == "__main__":
    main()
