from sqlalchemy.orm import Session
from backend.models.data import Data
from backend.schemas.data import DataCreate, DataUpdate
from backend.models.user import User
from backend.models.phone import Phone
from backend.models.device import Device
from backend.models.workout import Workout
from typing import List


def create_data_list(db: Session, data_list: List[DataCreate]) -> List[Data]:
    created = []
    for data in data_list:
        # Optional: Check FK existence (skip if FK constraints are enforced at DB level)
        if not db.query(User).filter_by(user_id=data.user_id).first():
            raise ValueError(f"user_id {data.user_id} not found")
        if not db.query(Phone).filter_by(phone_id=data.phone_id).first():
            raise ValueError(f"phone_id {data.phone_id} not found")
        if not db.query(Device).filter_by(device_id=data.device_id).first():
            raise ValueError(f"device_id {data.device_id} not found")
        if data.workout_id:
            if not db.query(Workout).filter_by(workout_id=data.workout_id, user_id=data.user_id).first():
                raise ValueError(f"(workout_id, user_id) ({data.workout_id}, {data.user_id}) not found in workouts")

        db_data = Data(**data.model_dump())
        db.add(db_data)
        created.append(db_data)

    db.commit()
    for obj in created:
        db.refresh(obj)
    return created

# def create_multiple_data(db: Session, data: List[DataCreate]):
#     created = []
#     for data in data_list:
#         # Optional: Check FK existence (skip if FK constraints are enforced at DB level)
#         if not db.query(User).filter_by(user_id=data.user_id).first():
#             raise ValueError(f"user_id {data.user_id} not found")
#         if not db.query(Phone).filter_by(phone_id=data.phone_id).first():
#             raise ValueError(f"phone_id {data.phone_id} not found")
#         if not db.query(Device).filter_by(device_id=data.device_id).first():
#             raise ValueError(f"device_id {data.device_id} not found")
#         if data.workout_id:
#             if not db.query(Workout).filter_by(workout_id=data.workout_id, user_id=data.user_id).first():
#                 raise ValueError(f"(workout_id, user_id) ({data.workout_id}, {data.user_id}) not found in workouts")

#         db_data = Data(**data.model_dump())
#         db.add(db_data)
#         created.append(db_data)

#     db.commit()
#     for obj in created:
#         db.refresh(obj)
#     return created


def get_all_data(db: Session):
    return db.query(Data).all()

def get_data_by_composite_key(db: Session, timestamp, user_id, phone_id, device_id):
    return db.query(Data).filter(
        Data.timestamp == timestamp,
        Data.user_id == user_id,
        Data.phone_id == phone_id,
        Data.device_id == device_id
    ).first()

def update_data(db: Session, timestamp, user_id, phone_id, device_id, data_update: DataUpdate):
    db_data = get_data_by_composite_key(db, timestamp, user_id, phone_id, device_id)
    if not db_data:
        return None
    for key, value in data_update.model_dump(exclude_unset=True).items():
        setattr(db_data, key, value)
    db.commit()
    db.refresh(db_data)
    return db_data

def delete_data(db: Session, timestamp, user_id, phone_id, device_id):
    db_data = get_data_by_composite_key(db, timestamp, user_id, phone_id, device_id)
    if not db_data:
        return None
    db.delete(db_data)
    db.commit()
    return db_data
