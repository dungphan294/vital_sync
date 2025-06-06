from sqlalchemy import Column, String, TIMESTAMP
from backend.database import Base


class Phone(Base):
    __tablename__ = "phones"

    phone_id = Column(String, primary_key=True, nullable=False)
    model = Column(String)
    os = Column(String)
    serial_number = Column(String)
    created_time = Column(TIMESTAMP, nullable=False)
    updated_time = Column(TIMESTAMP)
