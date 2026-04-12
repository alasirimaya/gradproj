from fastapi import APIRouter, UploadFile, File, Form, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Application, Job

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
    db: Session = Depends(get_db)
):
    job = db.query(Job).filter(Job.id == job_id).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    cv_content = await cv.read()

    new_app = Application(
        job_id=job_id,
        user_id=user_id,
        info=info,
        cv_filename=cv.filename,
        cv_data=cv_content,
    )

    # إذا عندك حقل status في المودل بيضبط
    if hasattr(new_app, "status"):
        new_app.status = "Under Review"

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
            "status": getattr(new_app, "status", "Under Review"),
        },
    }


@router.get("/")
def get_all_applications(db: Session = Depends(get_db)):
    applications = db.query(Application).all()

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
            "info": app.info,
            "cv_filename": app.cv_filename,
        })

    return results


@router.get("/user/{user_id}")
def get_user_applications(user_id: int, db: Session = Depends(get_db)):
    applications = db.query(Application).filter(Application.user_id == user_id).all()

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
            "info": app.info,
            "cv_filename": app.cv_filename,
        })

    return results