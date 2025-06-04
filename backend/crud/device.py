from sqlalchemy.orm import Session
from backend.models.device import Device
from backend.schemas.device import DeviceCreate, DeviceUpdate
from backend.models.data import Data
from backend.crud.crud_shared import save_one_record, save_multiple_records
from typing import List

def create_device(db: Session, device: DeviceCreate):
    return save_one_record(db, Device, device)

def create_devices(db: Session, devices: List[DeviceCreate]):
    return save_multiple_records(db, Device, devices)

def get_devices(db: Session):
    return db.query(Device).all()

def get_device_by_id(db: Session, device_id: str):
    return db.query(Device).filter(Device.device_id == device_id).first()

def update_device(db: Session, device_id: str, device_data: DeviceUpdate):
    db_device = get_device_by_id(db, device_id)
    if not db_device:
        return None
    for key, value in device_data.model_dump(exclude_unset=True).items():
        setattr(db_device, key, value)
    db.commit()
    db.refresh(db_device)
    return db_device

def delete_device(db: Session, device_id: str):
    if db.query(Data).filter_by(device_id=device_id).first():
        raise ValueError(f"Cannot delete device '{device_id}' — referenced in data records")

    db_device = get_device_by_id(db, device_id)
    if not db_device:
        return None
    db.delete(db_device)
    db.commit()
    return db_device