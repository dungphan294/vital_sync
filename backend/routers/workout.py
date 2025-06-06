from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from backend.database import get_db
from backend.schemas.workout import WorkoutCreate, WorkoutUpdate, WorkoutResponse
from backend.crud import workout as crud_workout
from typing import List

router = APIRouter(prefix="/workouts", tags=["Workouts"])

@router.post("/", response_model=WorkoutResponse)
def create_data(data: WorkoutCreate, db: Session = Depends(get_db)):
    try:
        return crud_workout.create_workouts(db, [data])[0]
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/bulk", response_model=List[WorkoutResponse])
def create_bulk_data(data_list: List[WorkoutCreate], db: Session = Depends(get_db)):
    try:
        return crud_workout.create_workouts(db, data_list)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

    
# @router.post("/", response_model=WorkoutResponse)
# def create_workout(workout: WorkoutCreate, db: Session = Depends(get_db)):
#     return crud_workout.create_workout(db, workout)

@router.get("/", response_model=list[WorkoutResponse])
def read_workouts(db: Session = Depends(get_db)):
    return crud_workout.get_workouts(db)

@router.get("/{user_id}/{workout_id}", response_model=WorkoutResponse)
def read_workout(user_id: str, workout_id: str, db: Session = Depends(get_db)):
    workout = crud_workout.get_workout_by_id(db, workout_id, user_id)
    if not workout:
        raise HTTPException(status_code=404, detail="Workout not found")
    return workout

@router.put("/{user_id}/{workout_id}", response_model=WorkoutResponse)
def update_workout(user_id: str, workout_id: str, data: WorkoutUpdate, db: Session = Depends(get_db)):
    updated = crud_workout.update_workout(db, workout_id, user_id, data)
    if not updated:
        raise HTTPException(status_code=404, detail="Workout not found")
    return updated

@router.delete("/{user_id}/{workout_id}", response_model=WorkoutResponse)
def delete_workout(user_id: str, workout_id: str, db: Session = Depends(get_db)):
    deleted = crud_workout.delete_workout(db, workout_id, user_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Workout not found")
    return deleted
