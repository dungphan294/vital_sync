from sqlalchemy.orm import Session
from backend.models.data import Data, Pagination
from backend.schemas.data import DataCreate, DataUpdate
from backend.models.user import User
from backend.models.phone import Phone
from backend.models.device import Device
from backend.models.workout import Workout
from backend.crud.workout import create_workouts
from typing import List, Optional


def create_data_list(db: Session, data_list: List[DataCreate]) -> List[Data]:
    user_ids = {u.user_id for u in db.query(User.user_id).all()}
    phone_ids = {p.phone_id for p in db.query(Phone.phone_id).all()}
    device_ids = {d.device_id for d in db.query(Device.device_id).all()}
    workout_keys = {(w.workout_id, w.user_id)
                    for w in db.query(Workout.workout_id, Workout.user_id).all()}

    created = []
    for data in data_list:
        if data.user_id not in user_ids:
            raise ValueError(f"user_id {data.user_id} not found")
        if data.phone_id not in phone_ids:
            raise ValueError(f"phone_id {data.phone_id} not found")
        if data.device_id not in device_ids:
            raise ValueError(f"device_id {data.device_id} not found")
        if data.workout_id and (data.workout_id, data.user_id) not in workout_keys:
            from backend.schemas.workout import WorkoutCreate
            workout_create = WorkoutCreate(
                workout_id=data.workout_id,
                user_id=data.user_id,
                start_time=data.timestamp,
            )
            create_workouts(db, [workout_create])
            # Update workout_keys to include the newly created workout
            workout_keys.add((data.workout_id, data.user_id))
            print(f"Created workout {data.workout_id} for user {data.user_id}")
        db_data = Data(**data.model_dump())
        db.add(db_data)
        created.append(db_data)

    db.commit()
    for obj in created:
        db.refresh(obj)
    return created


def get_all_data(db: Session):
    return db.query(Data).all()


def get_data_by_fields(
    db: Session,
    timestamp: Optional[str] = None,
    user_id: Optional[str] = None,
    phone_id: Optional[str] = None,
    device_id: Optional[str] = None,
    workout_id: Optional[str] = None
) -> Optional[Data]:
    query = db.query(Data)
    if timestamp:
        query = query.filter(Data.timestamp == timestamp)
    if user_id:
        query = query.filter(Data.user_id == user_id)
    if phone_id:
        query = query.filter(Data.phone_id == phone_id)
    if device_id:
        query = query.filter(Data.device_id == device_id)
    if workout_id:
        query = query.filter(Data.workout_id == workout_id)
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
    query = db.query(Data)

    # Apply all filters in a dictionary comprehension
    filters = {
        Data.timestamp: timestamp,
        Data.user_id: user_id,
        Data.phone_id: phone_id,
        Data.device_id: device_id,
        Data.workout_id: workout_id
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
    data_update: DataUpdate = None
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
