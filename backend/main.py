from fastapi import FastAPI
from backend.database import Base, engine  # adjust import if needed
from backend.routers import user, phone, device, workout, data, user_device, user_phone  # under backend/api/from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.cors import CORSMiddleware

# Ensure the tables are created before the app starts
Base.metadata.create_all(bind=engine)

app = FastAPI()
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"])

# Include routes
# app.include_router(item.router, prefix="/items", tags=["items"])
app.include_router(user.router)
app.include_router(phone.router)
app.include_router(device.router)
app.include_router(user_phone.router)
app.include_router(user_device.router)
app.include_router(workout.router)
app.include_router(data.router)
