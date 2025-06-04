import sqlite3
from datetime import datetime

### SQLite database setup for storing LED states and heart rate data
class SqliteDB:
    """A simple database connection class to manage SQLite database operations."""
    
    def __init__(self, db_name):
        """Initialize the database connection and create the table if not exists."""
        self.db_name = db_name
        self.conn = sqlite3.connect(self.db_name)
        self.cursor = self.conn.cursor()
        self._create_table()

    def _create_table(self):
        """Create the led_state table if it doesn't exist."""
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS led_state (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                state TEXT,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        
        # Create heart rate table
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS heart_rate (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                bpm INTEGER,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        self.conn.commit()

    def insert_led_state(self, state):
        """Insert LED state (HIGH/LOW) into the database."""
        try:
            self.cursor.execute("INSERT INTO led_state (state) VALUES (?)", (state,))
            self.conn.commit()  # Commit the transaction
            print(f"LED state '{state}' inserted successfully.")
        except sqlite3.Error as e:
            print(f"Error inserting data: {e}")

    def insert_heart_rate(self, bpm):
        """Insert heart rate data (BPM) into the database."""
        try:
            self.cursor.execute("INSERT INTO heart_rate (bpm) VALUES (?)", (bpm,))
            self.conn.commit()  # Commit the transaction
            print(f"Heart rate '{bpm}' BPM inserted successfully.")
        except sqlite3.Error as e:
            print(f"Error inserting heart rate data: {e}")

    def fetch_led_states(self):
        """Fetch all stored LED states."""
        self.cursor.execute("SELECT * FROM led_state")
        rows = self.cursor.fetchall()
        return rows
    
    def fetch_heart_rate(self):
        """Fetch all stored heart rate records."""
        self.cursor.execute("SELECT * FROM heart_rate")
        rows = self.cursor.fetchall()
        return rows

    def close_connection(self):
        """Close the database connection."""
        self.conn.close()
        print("Database connection closed.")

