from fastapi import APIRouter

from auth.router import router as auth_router
from jobs import router as jobs_router
from app.api.v1.recommendation import router as recommendation_router
from app.api.v1.applications import router as applications_router
from app.api.v1.users import router as users_router
from app.api.v1.profile_router import router as profile_router
from app.api.v1.hr_profile import router as hr_profile_router

api_router = APIRouter()

# Auth
api_router.include_router(auth_router, prefix="/auth")

# Jobs
api_router.include_router(jobs_router)

# Recommendation
api_router.include_router(
    recommendation_router,
    prefix="/recommend",
    tags=["Recommendation"],
)

# Applications
api_router.include_router(applications_router)

# Users
api_router.include_router(users_router)

# Profile (الجديد)
api_router.include_router(profile_router)

# Test route
@api_router.get("/ping")
def ping():
    return {"message": "pong"}
# Profile
api_router.include_router(profile_router)

# HR Profile
api_router.include_router(hr_profile_router)

# Test route
@api_router.get("/ping")
def ping():
    return {"message": "pong"}