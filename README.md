# vital_sync
Frontend &amp; Backend setup for Saxion - PINT project
## Project Overview

This project is designed for IoT applications and uses Docker for containerization. The stack includes:

- **Base OS:** Alpine Linux (lightweight and secure)
- **Database:** SQLite3 (embedded, serverless)
- **Backend:** FastAPI (Python, high-performance APIs)
- **Frontend:** Flutter (cross-platform UI)

All components are orchestrated using Docker images for easy deployment and scalability.

uvicorn backend.main:app --host 0.0.0.0 --port 443 --ssl-keyfile="/key.pem" --ssl-certfile="/cert.pem"
