from pydantic import BaseModel
from datetime import datetime

class UserPhoneBase(BaseModel):
    user_id: str
    phone_id: str

class UserPhoneCreate(UserPhoneBase):
    created_time: datetime
    updated_time: datetime | None = None

class UserPhoneUpdate(BaseModel):
    updated_time: datetime | None = None

class UserPhoneResponse(UserPhoneBase):
    created_time: datetime
    updated_time: datetime | None = None

    class Config:
        from_attributes = True