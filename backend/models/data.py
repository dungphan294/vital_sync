from sqlalchemy import Column, String, Integer, TIMESTAMP, ForeignKey, ForeignKeyConstraint
from backend.database import Base


class Data(Base):
    __tablename__ = "data"

    timestamp = Column(TIMESTAMP, primary_key=True)
    user_id = Column(String, ForeignKey(
        "users.user_id", ondelete="RESTRICT"), primary_key=True)
    phone_id = Column(String, ForeignKey("phones.phone_id",
                      ondelete="RESTRICT"), primary_key=True)
    device_id = Column(String, ForeignKey(
        "devices.device_id", ondelete="RESTRICT"), primary_key=True)
    workout_id = Column(String, nullable=True)

    heart_rate = Column(Integer)
    oxygen_saturation = Column(Integer)
    step_counts = Column(Integer)

    __table_args__ = (
        ForeignKeyConstraint(
            ['workout_id', 'user_id'],
            ['workouts.workout_id', 'workouts.user_id'],
            ondelete='RESTRICT',
            name='fk_data_workouts_composite'
        ),
    )


class Pagination(Data):
    """Pagination class for data retrieval."""
    total: int = 0
    total_pages: int = 0
    current_page: int = 0
    limit: int = 100
    data: list[Data] = []

    def __init__(self, total: int, total_pages: int, current_page: int, limit: int, data: list[Data]):
        if data is None:
            data = []
        self.total = total
        self.total_pages = total_pages
        self.current_page = current_page
        self.limit = limit
        self.data = data