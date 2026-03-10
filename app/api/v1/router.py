from fastapi import APIRouter

# Noura – Auth module integration
# This router handles user authentication endpoints (register, login, get current user)
from auth.router import router as auth_router
from jobs import router as jobs_router  # hajar


api_router = APIRouter()

# Noura – Include authentication routes under /auth
# This makes auth endpoints available under /api/v1/auth/*
api_router.include_router(auth_router, prefix="/auth")
api_router.include_router(jobs_router)  # hajar

@api_router.get("/ping")
def ping():
    return {"message": "pong-HAJAR"} 
    