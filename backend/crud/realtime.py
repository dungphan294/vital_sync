from sqlalchemy.orm import Session
from backend.models.realtime import Realtime, Pagination
from backend.schemas.realtime import RealtimeCreate, RealtimeUpdate
from typing import List, Optional


def create_data_list(db: Session, data_list: List[RealtimeCreate]) -> List[Realtime]:
    created = []
    for data in data_list:
        db_data = Realtime(**data.model_dump())
        db.add(db_data)
        created.append(db_data)

    db.commit()
    for obj in created:
        db.refresh(obj)
    return created


def get_all_data(db: Session):
    return db.query(Realtime).all()


def get_data_by_fields(
    db: Session,
    timestamp: Optional[str] = None,
    user_id: Optional[str] = None,
    phone_id: Optional[str] = None,
    device_id: Optional[str] = None,
    workout_id: Optional[str] = None
) -> Optional[Realtime]:
    query = db.query(Realtime)
    if timestamp:
        query = query.filter(Realtime.timestamp == timestamp)
    if user_id:
        query = query.filter(Realtime.user_id == user_id)
    if phone_id:
        query = query.filter(Realtime.phone_id == phone_id)
    if device_id:
        query = query.filter(Realtime.device_id == device_id)
    if workout_id:
        query = query.filter(Realtime.workout_id == workout_id)
    return query.first()


def search_data(
    db: Session,
    timestamp: Optional[str] = None,
    user_id: Optional[str] = None,
    phone_id: Optional[str] = None,
    device_id: Optional[str] = None,
    workout_id: Optional[str] = None,
    current_page: int = 0,
    limit: int = 100
):
    # Create base query
    query = db.query(Realtime)

    # Apply all filters in a dictionary comprehension
    filters = {
        Realtime.timestamp: timestamp,
        Realtime.user_id: user_id,
        Realtime.phone_id: phone_id,
        Realtime.device_id: device_id,
        Realtime.workout_id: workout_id
    }

    # Add only non-None filters
    query = query.filter(
        *(col == val for col, val in filters.items() if val is not None))

    # Calculate pagination with optimized parameters
    limit = min(max(1, limit), 1000)  # Ensure limit is between 1 and 1000
    # Ensure current_page is non-negative
    offset = max(0, current_page) * limit

    # Get total count and items in one pass
    total_count = query.count()
    items = query.offset(offset).limit(limit).all() if total_count > 0 else []

    return Pagination(
        total=total_count,
        total_pages=max(1, (total_count + limit - 1) // limit),
        current_page=current_page+1,
        limit=limit,
        data=items
    )


def update_data(
    db: Session,
    timestamp: Optional[str] = None,
    user_id: Optional[str] = None,
    phone_id: Optional[str] = None,
    device_id: Optional[str] = None,
    data_update: RealtimeUpdate = None
):
    db_data = get_data_by_fields(db, timestamp, user_id, phone_id, device_id)
    if not db_data:
        return None
    for key, value in data_update.model_dump(exclude_unset=True).items():
        setattr(db_data, key, value)
    db.commit()
    db.refresh(db_data)
    return db_data


def delete_data(
    db: Session,
    timestamp: Optional[str] = None,
    user_id: Optional[str] = None,
    phone_id: Optional[str] = None,
    device_id: Optional[str] = None
):
    db_data = get_data_by_fields(db, timestamp, user_id, phone_id, device_id)
    if not db_data:
        return None
    db.delete(db_data)
    db.commit()
    return db_data
