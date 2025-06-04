from sqlalchemy import Column, String, Integer, TIMESTAMP, ForeignKey, ForeignKeyConstraint
from backend.database import Base

class Data(Base):
    __tablename__ = "data"

    timestamp = Column(TIMESTAMP, primary_key=True)
    user_id = Column(String, ForeignKey("users.user_id", ondelete="RESTRICT"), primary_key=True)
    phone_id = Column(String, ForeignKey("phones.phone_id", ondelete="RESTRICT"), primary_key=True)
    device_id = Column(String, ForeignKey("devices.device_id", ondelete="RESTRICT"), primary_key=True)
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
