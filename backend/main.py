from fastapi import FastAPI
from backend.database import Base, engine  # adjust import if needed
from backend.routers import user, phone, device, workout, data  # under backend/api/

# Ensure the tables are created before the app starts
Base.metadata.create_all(bind=engine)

app = FastAPI()

# Include routes
# app.include_router(item.router, prefix="/items", tags=["items"])
app.include_router(user.router)
app.include_router(phone.router)
app.include_router(device.router)
app.include_router(workout.router)
app.include_router(data.router)
