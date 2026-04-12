from fastapi import APIRouter
from auth.router import router as auth_router
from jobs import router as jobs_router

<<<<<<< HEAD
from app.api.v1.recommendation import router as recommendation_router

=======
from .applications import router as applications_router
>>>>>>> 8849d18182e7c818c2c50ad3d597fc463cda92aa
api_router = APIRouter()

# Authentication routes
api_router.include_router(auth_router, prefix="/auth")
<<<<<<< HEAD

# Jobs routes
api_router.include_router(jobs_router)

# Recommendation routes
api_router.include_router(recommendation_router, prefix="/recommend", tags=["Recommendation"])

=======
api_router.include_router(jobs_router)  # hajar
api_router.include_router(applications_router)
>>>>>>> 8849d18182e7c818c2c50ad3d597fc463cda92aa
@api_router.get("/ping")
def ping():
    return {"message": "pong-HAJAR"}


    