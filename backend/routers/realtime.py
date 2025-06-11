from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from backend.database import get_db
from backend.schemas.realtime import RealtimeCreate, RealtimeUpdate, RealtimeResponse, Pagination
from backend.crud import realtime as crud_data
from typing import List, Optional

router = APIRouter(prefix="/realtime", tags=["Realtime"])

@router.post("/", response_model=RealtimeResponse)
def create_data(realtime: RealtimeCreate, db: Session = Depends(get_db)):
    try:
        return crud_data.create_data_list(db, [realtime])[0]
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/bulk", response_model=List[RealtimeResponse])
def create_bulk_data(data_list: List[RealtimeCreate], db: Session = Depends(get_db)):
    try:
        return crud_data.create_data_list(db, data_list)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/", response_model=List[RealtimeResponse])
def get_all_data(db: Session = Depends(get_db)):
    return crud_data.get_all_data(db)

@router.get("/get", response_model=RealtimeResponse)
def get_data(
    timestamp: Optional[str] = Query(None),
    user_id: Optional[str] = Query(None),
    phone_id: Optional[str] = Query(None),
    device_id: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
    realtime = crud_data.get_data_by_fields(db, timestamp, user_id, phone_id, device_id)
    if not realtime:
        raise HTTPException(status_code=404, detail="Realtime not found")
    return realtime

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
    if realtime := crud_data.search_data(
        db, 
        timestamp, 
        user_id, 
        phone_id, 
        device_id, 
        workout_id,
        current_page=page,
        limit=limit
    ):
        return realtime
    raise HTTPException(status_code=404, detail="No realtime found")

@router.put("/", response_model=RealtimeResponse)
def update_data(
    timestamp: Optional[str] = Query(None),
    user_id: Optional[str] = Query(None),
    phone_id: Optional[str] = Query(None),
    device_id: Optional[str] = Query(None),
    update: RealtimeUpdate = None,
    db: Session = Depends(get_db)
):
    realtime = crud_data.update_data(db, timestamp, user_id, phone_id, device_id, update)
    if not realtime:
        raise HTTPException(status_code=404, detail="Realtime not found")
    return realtime

@router.delete("/", response_model=RealtimeResponse)
def delete_data(
    timestamp: Optional[str] = Query(None),
    user_id: Optional[str] = Query(None),
    phone_id: Optional[str] = Query(None),
    device_id: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
    realtime = crud_data.delete_data(db, timestamp, user_id, phone_id, device_id)
    if not realtime:
        raise HTTPException(status_code=404, detail="Realtime not found")
    return realtime
