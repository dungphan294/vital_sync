from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from backend.database import get_db
from backend.schemas.phone import PhoneCreate, PhoneUpdate, PhoneResponse
from backend.crud import phone as crud_phone
from typing import List

router = APIRouter(prefix="/phones", tags=["Phones"])

@router.post("/", response_model=PhoneResponse)
def create_phone(data: PhoneCreate, db: Session = Depends(get_db)):
    try:
        return crud_phone.create_phone(db, data)
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/bulk", response_model=List[PhoneResponse])
def create_bulk_phones(data: List[PhoneCreate], db: Session = Depends(get_db)):
    try:
        return crud_phone.create_phones(db, data)
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
# @router.post("/", response_model=PhoneResponse)
# def create_phone(phone: PhoneCreate, db: Session = Depends(get_db)):
#     return crud_phone.create_phone(db, phone)

@router.get("/", response_model=list[PhoneResponse])
def read_phones(db: Session = Depends(get_db)):
    return crud_phone.get_phones(db)

@router.get("/{phone_id}", response_model=PhoneResponse)
def read_phone(phone_id: str, db: Session = Depends(get_db)):
    phone = crud_phone.get_phone_by_id(db, phone_id)
    if not phone:
        raise HTTPException(status_code=404, detail="Phone not found")
    return phone

@router.put("/{phone_id}", response_model=PhoneResponse)
def update_phone(phone_id: str, phone: PhoneUpdate, db: Session = Depends(get_db)):
    updated = crud_phone.update_phone(db, phone_id, phone)
    if not updated:
        raise HTTPException(status_code=404, detail="Phone not found")
    return updated

@router.delete("/{phone_id}", response_model=PhoneResponse)
def delete_phone(phone_id: str, db: Session = Depends(get_db)):
    deleted = crud_phone.delete_phone(db, phone_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Phone not found")
    return deleted
