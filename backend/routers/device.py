from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from backend.database import get_db
from backend.schemas.device import DeviceCreate, DeviceUpdate, DeviceResponse
from backend.crud import device as crud_device
from typing import List

router = APIRouter(prefix="/devices", tags=["Devices"])


@router.post("/", response_model=DeviceResponse)
def create_device(device: DeviceCreate, db: Session = Depends(get_db)):
    return crud_device.create_device(db, device)


@router.post("/bulk", response_model=List[DeviceResponse])
def create_devices(devices: List[DeviceCreate], db: Session = Depends(get_db)):
    return crud_device.create_devices(db, devices)

# @router.post("/", response_model=DeviceResponse)
# def create_device(device: DeviceCreate, db: Session = Depends(get_db)):
#     return crud_device.create_device(db, device)


@router.get("/", response_model=list[DeviceResponse])
def read_devices(db: Session = Depends(get_db)):
    return crud_device.get_devices(db)


@router.get("/{device_id}", response_model=DeviceResponse)
def read_device(device_id: str, db: Session = Depends(get_db)):
    device = crud_device.get_device_by_id(db, device_id)
    if not device:
        raise HTTPException(status_code=404, detail="Device not found")
    return device


@router.put("/{device_id}", response_model=DeviceResponse)
def update_device(device_id: str, device: DeviceUpdate, db: Session = Depends(get_db)):
    updated = crud_device.update_device(db, device_id, device)
    if not updated:
        raise HTTPException(status_code=404, detail="Device not found")
    return updated


@router.delete("/{device_id}", response_model=DeviceResponse)
def delete_device(device_id: str, db: Session = Depends(get_db)):
    deleted = crud_device.delete_device(db, device_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Device not found")
    return deleted
