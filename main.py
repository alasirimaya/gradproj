from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from database import engine
import models

# Create DB tables on startup
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Job Recommendation Backend (Sandbox)")

# CORS (for frontend later)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def root():
    return {"status": "ok", "message": "Sandbox backend is running"}
