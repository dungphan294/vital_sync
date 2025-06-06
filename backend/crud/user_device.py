from sqlalchemy.orm import Session
from backend.models.user_device import UserDevice
from backend.schemas.user_device import UserDeviceCreate, UserDeviceUpdate
from backend.models.user import User
from backend.models.device import Device
from typing import List, Optional


# def create_user_device(db: Session, user_device: UserDevice):
#     db_user_device = UserDevice(**user_device.model_dump())
#     db.add(db_user_device)
#     db.commit()
#     db.refresh(db_user_device)
#     return db_user_device

def create_user_devices(db: Session, user_device_list: List[UserDeviceCreate]) -> List[UserDevice]:
    created = []
    for data in user_device_list:
        # Optional: Check FK existence (skip if FK constraints are enforced at DB level)
        if not db.query(User).filter_by(user_id=data.user_id).first():
            raise ValueError(f"user_id {data.user_id} not found")
        if not db.query(Device).filter_by(device_id=data.device_id).first():
            raise ValueError(f"device_id {data.device_id} not found")

        db_data = UserDevice(**data.model_dump())
        db.add(db_data)
        created.append(db_data)

    db.commit()
    for obj in created:
        db.refresh(obj)
    return created


def get_user_devices(db: Session):
    return db.query(UserDevice).all()


def get_user_device_by_id(
    db: Session, 
    user_id: Optional[str] = None, 
    device_id: Optional[str] = None):
    query = db.query(UserDevice)
    if user_id:
        query = query.filter(UserDevice.user_id == user_id)
    if device_id:
        query = query.filter(UserDevice.device_id == device_id)
    return query.first()

def search_user_devices(
    db: Session, 
    user_id: Optional[str] = None, 
    device_id: Optional[str] = None) -> List[UserDevice]:
    query = db.query(UserDevice)
    if user_id:
        query = query.filter(UserDevice.user_id == user_id)
    if device_id:
        query = query.filter(UserDevice.device_id == device_id)
    return query.all()

def update_user_device(db: Session, user_id: str, device_id: str, phone_data: UserDeviceUpdate):
    db_user_device = get_user_device_by_id(db, user_id, device_id)
    if not db_user_device:
        return None
    for key, value in phone_data.model_dump(exclude_unset=True).items():
        setattr(db_user_device, key, value)
    db.commit()
    db.refresh(db_user_device)
    return db_user_device


def delete_user_phone(db: Session, user_id: str, device_id: str):
    db_user_device = get_user_device_by_id(db, user_id, device_id)
    if not db_user_device:
        return None
    db.delete(db_user_device)
    db.commit()
    return db_user_device
