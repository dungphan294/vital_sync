from pydantic import BaseModel
from datetime import datetime

class DeviceBase(BaseModel):
    serial_number: str | None = None
    model: str | None = None

class DeviceCreate(DeviceBase):
    device_id: str
    created_time: datetime
    updated_time: datetime | None = None

class DeviceUpdate(DeviceBase):
    updated_time: datetime | None = None

class DeviceResponse(DeviceCreate):
    class Config:
        from_attributes = True
