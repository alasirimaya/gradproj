from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Job

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



    