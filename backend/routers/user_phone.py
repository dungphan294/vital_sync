from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from backend.database import get_db
from backend.schemas.user_phone import UserPhoneCreate, UserPhoneUpdate, UserPhoneResponse
from backend.crud import user_phone as crud_user_phone
from typing import List, Optional

router = APIRouter(prefix="/user-phone", tags=["User Phone"])


@router.post("/", response_model=UserPhoneResponse)
def create_user_phone(data: UserPhoneCreate, db: Session = Depends(get_db)):
    try:
        return crud_user_phone.create_user_phones(db, [data])[0]
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/bulk", response_model=List[UserPhoneResponse])
def create_bulk_data(data_list: List[UserPhoneCreate], db: Session = Depends(get_db)):
    try:
        return crud_user_phone.create_user_phones(db, data_list)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/", response_model=List[UserPhoneResponse])
def read_user_phones(db: Session = Depends(get_db)):
    return crud_user_phone.get_user_phones(db)


# @router.get("/{user_id}/{device_id}", response_model=UserPhoneResponse)
# def read_user_phone(user_id: str, device_id: str, db: Session = Depends(get_db)):
#     user_phone = crud_user_phone.get_user_phone_by_id(
#         db, user_id, device_id)
#     if not user_phone:
#         raise HTTPException(status_code=404, detail="User device not found")
#     return user_phone

@router.get("/get", response_model=UserPhoneResponse)
def get_user_phone(
    user_id: Optional[str] = Query(None), 
    phone_id: Optional[str] = Query(None), 
    db: Session = Depends(get_db)
):
    user_phone = crud_user_phone.get_user_phone_by_id(db, user_id, phone_id)
    if not user_phone:
        raise HTTPException(status_code=404, detail="User phone not found")
    return user_phone

@router.get("/search", response_model=List[UserPhoneResponse])
def search_user_phones(
    user_id: Optional[str] = Query(None), 
    phone_id: Optional[str] = Query(None), 
    db: Session = Depends(get_db)
):
    user_phones = crud_user_phone.search_user_phones(db, user_id, phone_id)
    if not user_phones:
        raise HTTPException(status_code=404, detail="No user phones found")
    return user_phones

@router.put("/{user_id}/{device_id}", response_model=UserPhoneResponse)
def update_user_phone(user_id: str, device_id: str, data: UserPhoneUpdate, db: Session = Depends(get_db)):
    updated = crud_user_phone.update_user_phone(db, user_id, device_id, data)
    if not updated:
        raise HTTPException(status_code=404, detail="User device not found")
    return updated


@router.delete("/{user_id}/{device_id}", response_model=UserPhoneResponse)
def delete_user_phone(user_id: str, device_id: str, db: Session = Depends(get_db)):
    deleted = crud_user_phone.delete_user_phone(db, user_id, device_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="User device not found")
    return deleted
