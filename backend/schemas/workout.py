from pydantic import BaseModel
from datetime import datetime

class WorkoutBase(BaseModel):
    start_time: datetime | None = None
    end_time: datetime | None = None
    type: str | None = None

class WorkoutCreate(WorkoutBase):
    workout_id: str
    user_id: str  # foreign key
    # optionally add timestamps here

class WorkoutUpdate(WorkoutBase):
    pass  # optional fields only

class WorkoutResponse(WorkoutCreate):
    class Config:
        from_attributes = True
