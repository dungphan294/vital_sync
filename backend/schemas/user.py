from pydantic import BaseModel, EmailStr
from datetime import date, datetime

class UserBase(BaseModel):
    name: str
    phone_number: str | None = None
    dob: date | None = None
    updated_time: datetime | None = None

class UserCreate(UserBase):
    user_id: str
    username: str
    password: str
    email: EmailStr
    created_time: datetime

class UserSafeUpdate(UserBase):
    """Update only non-sensitive fields. Excludes password/email/username."""

class UserSecureUpdate(UserBase):
    password: str | None = None
    email: EmailStr | None = None
    old_password: str

class UserResponse(UserCreate):
    class Config:
        from_attributes = True

class UserLogin(BaseModel):
    username: str
    password: str
