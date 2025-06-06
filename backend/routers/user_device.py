from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from backend.database import get_db
from backend.schemas.user_device import UserDeviceCreate, UserDeviceUpdate, UserDeviceResponse
from backend.crud import user_device as crud_user_device
from typing import List, Optional

router = APIRouter(prefix="/user-device", tags=["User Device"])


@router.post("/", response_model=UserDeviceResponse)
def create_user_device(data: UserDeviceCreate, db: Session = Depends(get_db)):
    try:
        return crud_user_device.create_user_devices(db, [data])[0]
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/bulk", response_model=List[UserDeviceResponse])
def create_bulk_data(data_list: List[UserDeviceCreate], db: Session = Depends(get_db)):
    try:
        return crud_user_device.create_user_devices(db, data_list)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/", response_model=List[UserDeviceResponse])
def read_user_devices(db: Session = Depends(get_db)):
    return crud_user_device.get_user_devices(db)


@router.get("/get", response_model=UserDeviceResponse)
def get_user_device(
    user_id: Optional[str] = Query(None), 
    device_id: Optional[str] = Query(None), 
    db: Session = Depends(get_db)):
    user_device = crud_user_device.get_user_device_by_id(
        db, user_id, device_id)
    if not user_device:
        raise HTTPException(status_code=404, detail="User device not found")
    return user_device

@router.get("/search", response_model=List[UserDeviceResponse])
def search_user_devices(
    user_id: Optional[str] = Query(None), 
    device_id: Optional[str] = Query(None), 
    db: Session = Depends(get_db)):
    user_devices = crud_user_device.search_user_devices(db, user_id, device_id)
    if not user_devices:
        raise HTTPException(status_code=404, detail="No user devices found")
    return user_devices


@router.put("/{user_id}/{device_id}", response_model=UserDeviceResponse)
def update_user_device(user_id: str, device_id: str, data: UserDeviceUpdate, db: Session = Depends(get_db)):
    updated = crud_user_device.update_user_device(db, user_id, device_id, data)
    if not updated:
        raise HTTPException(status_code=404, detail="User device not found")
    return updated


@router.delete("/{user_id}/{device_id}", response_model=UserDeviceResponse)
def delete_user_device(user_id: str, device_id: str, db: Session = Depends(get_db)):
    deleted = crud_user_device.delete_user_phone(db, user_id, device_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="User device not found")
    return deleted
