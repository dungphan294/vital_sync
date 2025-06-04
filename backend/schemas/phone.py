from pydantic import BaseModel
from datetime import datetime

class PhoneBase(BaseModel):
    model: str | None = None
    os: str | None = None
    serial_number: str | None = None

class PhoneCreate(PhoneBase):
    phone_id: str
    created_time: datetime
    updated_time: datetime | None = None

class PhoneUpdate(PhoneBase):
    updated_time: datetime | None = None

class PhoneResponse(PhoneCreate):
    class Config:
        from_attributes = True
