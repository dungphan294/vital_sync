# crud/crud_shared.py
from sqlalchemy.orm import Session
from typing import List, Type
from pydantic import BaseModel

def save_multiple_records(db: Session, model_class: Type, items: List[BaseModel]):
    objects = [model_class(**item.model_dump()) for item in items]
    db.add_all(objects)
    db.commit()
    for obj in objects:
        db.refresh(obj)
    return objects

def save_one_record(db: Session, model_class: Type, item: BaseModel):
    return save_multiple_records(db, model_class, [item])[0]
