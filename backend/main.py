from fastapi import FastAPI
from backend.database import Base, engine  # adjust import if needed
from backend.routers import user, phone, device, workout, data, user_device, user_phone, realtime  # under backend/api/from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.cors import CORSMiddleware
# import ssl
# from fastapi.middleware.httpsredirect import HTTPSRedirectMiddleware

# Ensure the tables are created before the app starts
Base.metadata.create_all(bind=engine)

app = FastAPI()

# ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
# ssl_context.load_cert_chain('../../cert.pem', keyfile='../../key.pem')

app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"])
# app.add_middleware(HTTPSRedirectMiddleware)
# Include routes
# app.include_router(item.router, prefix="/items", tags=["items"])
app.include_router(user.router)
app.include_router(phone.router)
app.include_router(device.router)
app.include_router(user_phone.router)
app.include_router(user_device.router)
app.include_router(workout.router)
app.include_router(data.router)
app.include_router(realtime.router)
