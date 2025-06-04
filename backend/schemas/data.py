from pydantic import BaseModel
from datetime import datetime

class DataBase(BaseModel):
    workout_id: str | None = None
    heart_rate: int | None = None
    oxygen_saturation: int | None = None
    step_counts: int | None = None

class DataCreate(DataBase):
    timestamp: datetime
    user_id: str
    phone_id: str
    device_id: str

class DataUpdate(DataBase):
    pass  # all fields optional

class DataResponse(DataCreate):
    class Config:
        from_attributes = True
