from pydantic import BaseModel
from datetime import datetime


class RealtimeBase(BaseModel):
    workout_id: str | None = None
    heart_rate: int | None = None
    oxygen_saturation: int | None = None
    step_counts: int | None = None


class RealtimeCreate(RealtimeBase):
    timestamp: datetime
    user_id: str
    phone_id: str
    device_id: str


class RealtimeUpdate(RealtimeBase):
    pass  # all fields optional


class RealtimeResponse(RealtimeCreate):
    class Config:
        from_attributes = True


class Pagination(BaseModel):
    total: int = 0
    total_pages: int = 0
    current_page: int = 0
    limit: int = 100
    Realtime: list[RealtimeResponse] = []

    def __init__(self, total: int, total_pages: int, current_page: int, limit: int, Realtime: list[RealtimeResponse]):
        if Realtime is None:
            Realtime = []
        self.total = total
        self.total_pages = total_pages
        self.current_page = current_page
        self.limit = limit
        self.Realtime = Realtime
