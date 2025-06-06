from pydantic import BaseModel
from datetime import datetime

class UserDeviceBase(BaseModel):
    user_id: str
    device_id: str

class UserDeviceCreate(UserDeviceBase):
    created_time: datetime
    updated_time: datetime | None = None

class UserDeviceUpdate(BaseModel):
    updated_time: datetime | None = None

class UserDeviceResponse(UserDeviceBase):
    created_time: datetime
    updated_time: datetime | None = None

    class Config:
        from_attributes = True
