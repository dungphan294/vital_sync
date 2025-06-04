from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from backend.database import get_db
from backend.schemas.item import ItemCreate, ItemResponse
from backend.crud import item as crud_item

router = APIRouter()

@router.post("/", response_model=ItemResponse)
def create(item: ItemCreate, db: Session = Depends(get_db)):
    return crud_item.create_item(db, item)

@router.get("/{item_id}", response_model=ItemResponse)
def read(item_id: int, db: Session = Depends(get_db)):
    try:
        db_item = crud_item.get_item(db, item_id)
        if db_item is None:
            raise HTTPException(status_code=404, detail="Item not found")
        return db_item
    except Exception as e:
        print("ERROR:", e)
        raise HTTPException(status_code=500, detail="Internal Error")


@router.get("/", response_model=list[ItemResponse])
def read_all(db: Session = Depends(get_db)):
    return crud_item.get_all_items(db)
