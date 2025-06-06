from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from backend.database import get_db
from backend.schemas.data import DataCreate, DataUpdate, DataResponse, Pagination
from backend.crud import data as crud_data
from typing import List, Optional

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

@router.get("/", response_model=List[DataResponse])
def get_all_data(db: Session = Depends(get_db)):
    return crud_data.get_all_data(db)

@router.get("/get", response_model=DataResponse)
def get_data(
    timestamp: Optional[str] = Query(None),
    user_id: Optional[str] = Query(None),
    phone_id: Optional[str] = Query(None),
    device_id: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
    data = crud_data.get_data_by_fields(db, timestamp, user_id, phone_id, device_id)
    if not data:
        raise HTTPException(status_code=404, detail="Data not found")
    return data

@router.get("/search", response_model=Pagination)
def search_data(
    timestamp: Optional[str] = None,
    user_id: Optional[str] = None,
    phone_id: Optional[str] = None,
    device_id: Optional[str] = None,
    workout_id: Optional[str] = None,
    page: int = Query(0, ge=0),
    limit: int = Query(100, le=1000),
    db: Session = Depends(get_db)
):
    if data := crud_data.search_data(
        db, 
        timestamp, 
        user_id, 
        phone_id, 
        device_id, 
        workout_id,
        current_page=page,
        limit=limit
    ):
        return data
    raise HTTPException(status_code=404, detail="No data found")

@router.put("/", response_model=DataResponse)
def update_data(
    timestamp: Optional[str] = Query(None),
    user_id: Optional[str] = Query(None),
    phone_id: Optional[str] = Query(None),
    device_id: Optional[str] = Query(None),
    update: DataUpdate = None,
    db: Session = Depends(get_db)
):
    data = crud_data.update_data(db, timestamp, user_id, phone_id, device_id, update)
    if not data:
        raise HTTPException(status_code=404, detail="Data not found")
    return data

@router.delete("/", response_model=DataResponse)
def delete_data(
    timestamp: Optional[str] = Query(None),
    user_id: Optional[str] = Query(None),
    phone_id: Optional[str] = Query(None),
    device_id: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
    data = crud_data.delete_data(db, timestamp, user_id, phone_id, device_id)
    if not data:
        raise HTTPException(status_code=404, detail="Data not found")
    return data
