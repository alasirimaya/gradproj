from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Job

# NEW: استدعاء خدمة تخزين الـ Embedding
from app.api.v1.embedding_service import save_job_embedding

router = APIRouter(
    prefix="/jobs",
    tags=["Jobs"]
)

@router.post("/")
def create_job(
    title: str,
    company: str,
    description: str = "",
    skills: str = "",
    db: Session = Depends(get_db)
):
    new_job = Job(
        title=title,
        company=company,
        description=description,
        skills=skills
    )
    db.add(new_job)
    db.commit()
    db.refresh(new_job)

    # NEW: تخزين embedding للوظيفة الجديدة
    save_job_embedding(db, new_job)

    return new_job


@router.get("/")
def get_all_jobs(db: Session = Depends(get_db)):
    return db.query(Job).all()


@router.get("/{job_id}")
def get_job(job_id: int, db: Session = Depends(get_db)):
    job = db.query(Job).filter(Job.id == job_id).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    return job




    