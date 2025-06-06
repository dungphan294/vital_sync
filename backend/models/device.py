from sqlalchemy import Column, String, TIMESTAMP
from backend.database import Base


class Device(Base):
    __tablename__ = "devices"

    device_id = Column(String, primary_key=True, nullable=False)
    serial_number = Column(String, unique=True)
    model = Column(String)
    created_time = Column(TIMESTAMP, nullable=False)
    updated_time = Column(TIMESTAMP)
