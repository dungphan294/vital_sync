from sqlalchemy import Column, String, Integer, TIMESTAMP, ForeignKey, ForeignKeyConstraint
from backend.database import Base


class Realtime(Base):
    __tablename__ = "realtime"

    timestamp = Column(TIMESTAMP, primary_key=True)
    user_id = Column(String, nullable=True)
    phone_id = Column(String, nullable=True)
    device_id = Column(String, nullable=True)
    workout_id = Column(String, nullable=True)
    heart_rate = Column(Integer)
    oxygen_saturation = Column(Integer)
    step_counts = Column(Integer)


class Pagination(Realtime):
    """Pagination class for data retrieval."""
    total: int = 0
    total_pages: int = 0
    current_page: int = 0
    limit: int = 100
    data: list[Realtime] = []

    def __init__(self, total: int, total_pages: int, current_page: int, limit: int, data: list[Realtime]):
        if data is None:
            data = []
        self.total = total
        self.total_pages = total_pages
        self.current_page = current_page
        self.limit = limit
        self.data = data