from sqlalchemy import Column, String, TIMESTAMP, ForeignKey
from backend.database import Base


class Workout(Base):
    __tablename__ = "workouts"

    workout_id = Column(String, primary_key=True)
    user_id = Column(String, ForeignKey("users.user_id", onupdate="NO ACTION",
                     ondelete="RESTRICT", name="fk_workouts_user_id_users"), primary_key=True)
    start_time = Column(TIMESTAMP)
    end_time = Column(TIMESTAMP)
    type = Column(String)
