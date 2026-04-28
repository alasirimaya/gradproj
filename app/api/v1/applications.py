from fastapi import APIRouter, UploadFile, File, Form, Depends, HTTPException
from sqlalchemy.orm import Session

from database import get_db
from models import Application, Job, User

router = APIRouter(
    prefix="/applications",
    tags=["Applications"]
)


@router.post("/apply")
async def apply_job(
    job_id: int = Form(...),
    user_id: int = Form(...),
    info: str = Form(""),
    cv: UploadFile = File(...),
    db: Session = Depends(get_db),
):
    job = db.query(Job).filter(Job.id == job_id).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    existing_application = db.query(Application).filter(
        Application.job_id == job_id,
        Application.user_id == user_id,
    ).first()

    if existing_application:
        raise HTTPException(
            status_code=400,
            detail="You already applied for this job",
        )

    cv_content = await cv.read()

    new_app = Application(
        job_id=job_id,
        user_id=user_id,
        info=info,
        cv_filename=cv.filename,
        cv_data=cv_content.decode("latin1"),
        status="Under Review",
    )

    db.add(new_app)
    db.commit()
    db.refresh(new_app)

    return {
        "message": "Application submitted successfully",
        "application": {
            "id": new_app.id,
            "job_id": new_app.job_id,
            "user_id": new_app.user_id,
            "job_title": job.title,
            "company": job.company,
            "status": new_app.status,
            "info": new_app.info,
            "cv_filename": new_app.cv_filename,
        },
    }


@router.get("/")
def get_all_applications(db: Session = Depends(get_db)):
    applications = db.query(Application).all()
    results = []

    for app in applications:
        job = db.query(Job).filter(Job.id == app.job_id).first()
        user = db.query(User).filter(User.id == app.user_id).first()

        results.append({
            "id": app.id,
            "job_id": app.job_id,
            "user_id": app.user_id,
            "applicant_name": user.full_name if user else "Unknown User",
            "applicant_email": user.email if user else "No Email",
            "job_title": job.title if job else "Unknown Job",
            "company": job.company if job else "Unknown Company",
            "status": getattr(app, "status", "Under Review"),
            "info": getattr(app, "info", ""),
            "cv_filename": getattr(app, "cv_filename", ""),
        })

    return results


@router.get("/user/{user_id}")
def get_user_applications(user_id: int, db: Session = Depends(get_db)):
    applications = db.query(Application).filter(
        Application.user_id == user_id
    ).all()

    results = []

    for app in applications:
        job = db.query(Job).filter(Job.id == app.job_id).first()

        results.append({
            "id": app.id,
            "job_id": app.job_id,
            "user_id": app.user_id,
            "job_title": job.title if job else "Unknown Job",
            "company": job.company if job else "Unknown Company",
            "status": getattr(app, "status", "Under Review"),
            "info": getattr(app, "info", ""),
            "cv_filename": getattr(app, "cv_filename", ""),
        })

    return results


@router.get("/job/{job_id}")
def get_job_applications(job_id: int, db: Session = Depends(get_db)):
    applications = db.query(Application).filter(
        Application.job_id == job_id
    ).all()

    results = []

    for app in applications:
        job = db.query(Job).filter(Job.id == app.job_id).first()
        user = db.query(User).filter(User.id == app.user_id).first()

        results.append({
            "id": app.id,
            "user_id": app.user_id,
            "job_id": app.job_id,
            "applicant_name": user.full_name if user else "Unknown User",
            "applicant_email": user.email if user else "No Email",
            "job_title": job.title if job else "Unknown Job",
            "company": job.company if job else "Unknown Company",
            "status": getattr(app, "status", "Under Review"),
            "info": getattr(app, "info", ""),
            "cv_filename": getattr(app, "cv_filename", ""),
            "created_at": str(app.created_at),
        })

    return results