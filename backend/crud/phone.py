from sqlalchemy.orm import Session
from backend.models.phone import Phone
from backend.models.user_phone import UserPhone
from backend.schemas.phone import PhoneCreate, PhoneUpdate
from backend.models.data import Data
from backend.crud.crud_shared import save_one_record, save_multiple_records
from typing import List


def create_phone(db: Session, device: PhoneCreate):
    return save_one_record(db, Phone, device)


def create_phones(db: Session, devices: List[PhoneUpdate]):
    return save_multiple_records(db, Phone, devices)


def get_phones(db: Session):
    return db.query(Phone).all()


def get_phone_by_id(db: Session, phone_id: str):
    return db.query(Phone).filter(Phone.phone_id == phone_id).first()


def update_phone(db: Session, phone_id: str, phone_data: PhoneUpdate):
    db_phone = get_phone_by_id(db, phone_id)
    if not db_phone:
        return None
    for key, value in phone_data.model_dump(exclude_unset=True).items():
        setattr(db_phone, key, value)
    db.commit()
    db.refresh(db_phone)
    return db_phone


def delete_phone(db: Session, phone_id: str):
    if db.query(Data).filter_by(phone_id=phone_id).first():
        raise ValueError(
            f"Cannot delete phone '{phone_id}' — referenced in data records")
    if db.query(UserPhone).filter_by(phone_id=phone_id).first():
        raise ValueError(
            f"Cannot delete phone '{phone_id}' — referenced in user_phone records")
    db_phone = get_phone_by_id(db, phone_id)
    if not db_phone:
        return None
    db.delete(db_phone)
    db.commit()
    return db_phone
