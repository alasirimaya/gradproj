from fastapi import APIRouter, UploadFile, File, Form, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Application

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
    # قراءة ملف الـ CV
    cv_content = await cv.read()

    new_app = Application(
        job_id=job_id,
        user_id=user_id,
        info=info,
        cv_filename=cv.filename,
        cv_data=cv_content
    )

    db.add(new_app)
    db.commit()
    db.refresh(new_app)

    return {"message": "Application submitted successfully", "application": new_app}
