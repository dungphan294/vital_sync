from sqlalchemy import Column, String, Date, TIMESTAMP
from backend.database import Base

class User(Base):
    __tablename__ = "users"

    user_id = Column(String, primary_key=True, index=True)
    username = Column(String, nullable=False)
    password = Column(String, nullable=False)
    name = Column(String)
    email = Column(String, unique=True, nullable=False)
    phone_number = Column(String)
    dob = Column(Date)
    created_time = Column(TIMESTAMP, nullable=False)
    updated_time = Column(TIMESTAMP)
