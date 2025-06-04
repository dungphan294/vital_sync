from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from backend.database import get_db
from backend.schemas.data import DataCreate, DataUpdate, DataResponse
from backend.crud import data as crud_data
from typing import List


router = APIRouter(prefix="/data", tags=["Data"])

@router.post("/", response_model=DataResponse)
def create_data(data: DataCreate, db: Session = Depends(get_db)):
    try:
        return crud_data.create_data_list(db, [data])[0]
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/bulk", response_model=List[DataResponse])
def create_bulk_data(data_list: List[DataCreate], db: Session = Depends(get_db)):
    try:
        return crud_data.create_data_list(db, data_list)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    
# @router.post("/", response_model=DataResponse)
# def create_data(data: DataCreate, db: Session = Depends(get_db)):
#     try:
#         return crud_data.create_data(db, data)
#     except ValueError as e:
#         raise HTTPException(status_code=400, detail=str(e))
    
@router.get("/", response_model=list[DataResponse])
def get_all_data(db: Session = Depends(get_db)):
    return crud_data.get_all_data(db)

@router.get("/{timestamp}/{user_id}/{phone_id}/{device_id}", response_model=DataResponse)
def get_data(timestamp: str, user_id: str, phone_id: str, device_id: str, db: Session = Depends(get_db)):
    data = crud_data.get_data_by_composite_key(db, timestamp, user_id, phone_id, device_id)
    if not data:
        raise HTTPException(status_code=404, detail="Data not found")
    return data

@router.put("/{timestamp}/{user_id}/{phone_id}/{device_id}", response_model=DataResponse)
def update_data(timestamp: str, user_id: str, phone_id: str, device_id: str, update: DataUpdate, db: Session = Depends(get_db)):
    data = crud_data.update_data(db, timestamp, user_id, phone_id, device_id, update)
    if not data:
        raise HTTPException(status_code=404, detail="Data not found")
    return data

@router.delete("/{timestamp}/{user_id}/{phone_id}/{device_id}", response_model=DataResponse)
def delete_data(timestamp: str, user_id: str, phone_id: str, device_id: str, db: Session = Depends(get_db)):
    data = crud_data.delete_data(db, timestamp, user_id, phone_id, device_id)
    if not data:
        raise HTTPException(status_code=404, detail="Data not found")
    return data
