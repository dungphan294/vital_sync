from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from backend.database import get_db
from backend.schemas.user import (
    UserCreate, UserSafeUpdate, UserSecureUpdate, UserResponse, UserLogin
)
from backend.crud import user as crud_user

router = APIRouter(prefix="/users", tags=["Users"])

@router.post("/", response_model=UserResponse)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    return crud_user.create_user(db, user)


@router.post("/login", response_model=UserResponse)
def login_user(credentials: UserLogin, db: Session = Depends(get_db)):
    user = crud_user.authenticate_user(db, credentials.username, credentials.password)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid username or password")
    return user


@router.get("/", response_model=list[UserResponse])
def get_all_users(db: Session = Depends(get_db)):
    return crud_user.get_users(db)

@router.get("/{user_id}", response_model=UserResponse)
def get_user(user_id: str, db: Session = Depends(get_db)):
    user = crud_user.get_user_by_id(db, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.put("/{user_id}/safe", response_model=UserResponse)
def update_user_safe(user_id: str, update_data: UserSafeUpdate, db: Session = Depends(get_db)):
    updated = crud_user.update_user_safe(db, user_id, update_data)
    if not updated:
        raise HTTPException(status_code=404, detail="User not found")
    return updated

@router.put("/{user_id}/secure", response_model=UserResponse)
def update_user_secure(user_id: str, update_data: UserSecureUpdate, db: Session = Depends(get_db)):
    updated = crud_user.update_user_secure(db, user_id, update_data)
    if not updated:
        raise HTTPException(status_code=403, detail="Old password incorrect or user not found")
    return updated

@router.delete("/{user_id}", response_model=UserResponse)
def delete_user(user_id: str, db: Session = Depends(get_db)):
    deleted = crud_user.delete_user(db, user_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="User not found")
    return deleted
