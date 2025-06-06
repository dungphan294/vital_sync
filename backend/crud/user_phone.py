from sqlalchemy.orm import Session
from backend.models.user_phone import UserPhone
from backend.schemas.user_phone import UserPhoneCreate, UserPhoneUpdate
from backend.models.user import User
from backend.models.phone import Phone
from typing import List

# def create_user_phone(db: Session, user_phone: UserPhone):
#     db_user_phone = UserPhone(**user_phone.model_dump())
#     db.add(db_user_phone)
#     db.commit()
#     db.refresh(db_user_phone)
#     return db_user_phone

def create_user_phones(db: Session, user_device_list: List[UserPhoneCreate]) -> List[UserPhone]:
    created = []
    for data in user_device_list:
        # Optional: Check FK existence (skip if FK constraints are enforced at DB level)
        if not db.query(User).filter_by(user_id=data.user_id).first():
            raise ValueError(f"user_id {data.user_id} not found")
        if not db.query(Phone).filter_by(phone_id=data.phone_id).first():
            raise ValueError(f"phone_id {data.phone_id} not found")

        db_data = UserPhone(**data.model_dump())
        db.add(db_data)
        created.append(db_data)

    db.commit()
    for obj in created:
        db.refresh(obj)
    return created



def get_user_phones(db: Session):
    return db.query(UserPhone).all()


def get_user_phone_by_id(db: Session, user_id: str, phone_id: str):
    query = db.query(UserPhone)
    if user_id:
        query = query.filter(UserPhone.user_id == user_id)
    if phone_id:
        query = query.filter(UserPhone.phone_id == phone_id)
    return query.first()

def search_user_phones(db: Session, user_id: str = None, phone_id: str = None) -> List[UserPhone]:
    query = db.query(UserPhone)
    if user_id:
        query = query.filter(UserPhone.user_id == user_id)
    if phone_id:
        query = query.filter(UserPhone.phone_id == phone_id)
    return query.all()


def update_user_phone(db: Session, user_id: str, phone_id: str, phone_data: UserPhoneUpdate):
    db_user_phone = get_user_phone_by_id(db, user_id, phone_id)
    if not db_user_phone:
        return None
    for key, value in phone_data.model_dump(exclude_unset=True).items():
        setattr(db_user_phone, key, value)
    db.commit()
    db.refresh(db_user_phone)
    return db_user_phone


def delete_user_phone(db: Session, user_id: str, phone_id: str):
    db_user_phone = get_user_phone_by_id(db, user_id, phone_id)
    if not db_user_phone:
        return None
    db.delete(db_user_phone)
    db.commit()
    return db_user_phone
