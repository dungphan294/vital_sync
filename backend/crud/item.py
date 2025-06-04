from sqlalchemy.orm import Session
from backend.models.item import Item
from backend.schemas.item import ItemCreate

def create_item(db: Session, item: ItemCreate) -> Item:
    db_item = Item(**item.model_dump())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item

def get_item(db: Session, item_id: int) -> Item | None:
    return db.query(Item).filter(Item.id == item_id).first()

def get_all_items(db: Session) -> list[Item]:
    return db.query(Item).all()
