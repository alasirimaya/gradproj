from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from models import User, Job
from app.api.v1.recommendation_module import recommend_for_user

router = APIRouter()

@router.get("/recommend/{user_id}")
def recommend_jobs(user_id: int, db: Session = Depends(get_db)):

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        return {"error": "User not found"}

    jobs = db.query(Job).all()

    recommendations = recommend_for_user(user, jobs)

    return {
        "user_id": user_id,
        "recommendations": recommendations
    }
