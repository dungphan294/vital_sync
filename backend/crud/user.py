import hashlib
from sqlalchemy.orm import Session
from backend.models.user import User
from backend.schemas.user import UserCreate, UserSafeUpdate, UserSecureUpdate
from backend.models.data import Data
from backend.models.workout import Workout
from backend.crud.crud_shared import save_one_record, save_multiple_records
from typing import List

def hash_password(password: str) -> str:
    return hashlib.sha256(password.encode("utf-8")).hexdigest()

def get_user_by_id(db: Session, user_id: str):
    return db.query(User).filter(User.user_id == user_id).first()

# def create_user(db: Session, user: UserCreate):
#     db_user = User(**user.model_dump())
#     db_user.password = hash_password(user.password)
#     db.add(db_user)
#     db.commit()
#     db.refresh(db_user)
#     return db_user

def create_user(db: Session, user: UserCreate):
    user_dict = user.model_dump()
    user_dict["password"] = hashlib.sha256(user_dict["password"].encode()).hexdigest()
    return save_one_record(db, User, user.model_copy(update=user_dict))

def create_users(db: Session, users: List[UserCreate]):
    hashed = []
    for user in users:
        user_dict = user.model_dump()
        user_dict["password"] = hashlib.sha256(user_dict["password"].encode()).hexdigest()
        hashed.append(user.model_copy(update=user_dict))
    return save_multiple_records(db, User, hashed)

def get_users(db: Session):
    return db.query(User).all()

def authenticate_user(db: Session, username: str, password: str):
    user = db.query(User).filter(User.username == username).first()
    if not user:
        return None
    if user.password != hash_password(password):
        return None
    return user

def update_user_safe(db: Session, user_id: str, update_data: UserSafeUpdate):
    db_user = get_user_by_id(db, user_id)
    if not db_user:
        return None
    update_dict = update_data.model_dump(exclude_unset=True)
    for key, value in update_dict.items():
        setattr(db_user, key, value)
    db.commit()
    db.refresh(db_user)
    return db_user

def update_user_secure(db: Session, user_id: str, update_data: UserSecureUpdate):
    db_user = get_user_by_id(db, user_id)
    if not db_user or not update_data.old_password:
        return None
    if db_user.password != hash_password(update_data.old_password):
        return None

    update_dict = update_data.model_dump(exclude_unset=True)
    if "password" in update_dict and update_dict["password"]:
        db_user.password = hash_password(update_dict["password"])
    if "email" in update_dict and update_dict["email"]:
        db_user.email = update_dict["email"]

    for key in ["name", "dob", "phone_number", "updated_time"]:
        if key in update_dict:
            setattr(db_user, key, update_dict[key])

    db.commit()
    db.refresh(db_user)
    return db_user


def delete_user(db: Session, user_id: str):
    if db.query(Workout).filter_by(user_id=user_id).first():
        raise ValueError(f"Cannot delete user '{user_id}' — referenced in workouts records")
    if db.query(Data).filter_by(user_id=user_id).first():
        raise ValueError(f"Cannot delete user '{user_id}' — referenced in data records")
    db_user = get_user_by_id(db, user_id)
    if not db_user:
        return None
    db.delete(db_user)
    db.commit()
    return db_user