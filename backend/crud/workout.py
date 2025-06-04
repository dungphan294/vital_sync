from sqlalchemy.orm import Session
from backend.models.user import User
from backend.models.workout import Workout
from backend.schemas.workout import WorkoutCreate, WorkoutUpdate
from backend.models.data import Data
from typing import List

def create_workouts(db: Session, workout_list: List[WorkoutCreate]) -> List[Workout]:
    created = []
    for data in workout_list:
        # Optional: Check FK existence (skip if FK constraints are enforced at DB level)
        if not db.query(User).filter_by(user_id=data.user_id).first():
            raise ValueError(f"user_id {data.user_id} not found")

        db_data = Data(**data.model_dump())
        db.add(db_data)
        created.append(db_data)

    db.commit()
    for obj in created:
        db.refresh(obj)
    return created

# def create_workout(db: Session, workout: WorkoutCreate):
#     # Check required foreign keys
#     if not db.query(User).filter_by(user_id=workout.user_id).first():
#         raise ValueError(f"User ID '{workout.user_id}' does not exist")
    
#     db_workout = Workout(**workout.model_dump())
#     db.add(db_workout)
#     db.commit()
#     db.refresh(db_workout)
#     return db_workout

def get_workouts(db: Session):
    return db.query(Workout).all()

def get_workout_by_id(db: Session, workout_id: str, user_id: str):
    return db.query(Workout).filter(Workout.workout_id == workout_id, Workout.user_id == user_id).first()

def update_workout(db: Session, workout_id: str, user_id: str, data: WorkoutUpdate):
    db_workout = get_workout_by_id(db, workout_id, user_id)
    if not db_workout:
        return None
    for key, value in data.model_dump(exclude_unset=True).items():
        setattr(db_workout, key, value)
    db.commit()
    db.refresh(db_workout)
    return db_workout


def delete_workout(db: Session, workout_id: str, user_id: str):
    if db.query(Data).filter_by(workout_id=workout_id).first():
        raise ValueError(f"Cannot delete workout '{workout_id}' — referenced in data records")

    db_workout = get_workout_by_id(db, workout_id, user_id)
    if not db_workout:
        return None
    db.delete(db_workout)
    db.commit()
    return db_workout