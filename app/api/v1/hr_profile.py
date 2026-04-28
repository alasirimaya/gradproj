from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session

from database import get_db
from models import HrProfile, User
from auth.router import get_current_user


router = APIRouter(
    prefix="/hr-profile",
    tags=["HR Profile"]
)


class HrProfileRequest(BaseModel):
    profile_picture: str = ""
    full_name: str = ""
    job_title: str = ""
    work_email: str = ""
    phone_number: str = ""
    office_location: str = ""
    bio: str = ""


@router.get("/me")
def get_hr_profile(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    profile = db.query(HrProfile).filter(
        HrProfile.user_id == current_user.id
    ).first()

    if not profile:
        return {
            "profile_picture": "",
            "full_name": current_user.full_name or "",
            "job_title": "",
            "work_email": current_user.email or "",
            "phone_number": "",
            "office_location": "",
            "bio": "",
        }

    return {
        "profile_picture": profile.profile_picture,
        "full_name": profile.full_name,
        "job_title": profile.job_title,
        "work_email": profile.work_email,
        "phone_number": profile.phone_number,
        "office_location": profile.office_location,
        "bio": profile.bio,
    }


@router.post("/save")
def save_hr_profile(
    payload: HrProfileRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    profile = db.query(HrProfile).filter(
        HrProfile.user_id == current_user.id
    ).first()

    if not profile:
        profile = HrProfile(user_id=current_user.id)
        db.add(profile)

    profile.profile_picture = payload.profile_picture
    profile.full_name = payload.full_name
    profile.job_title = payload.job_title
    profile.work_email = payload.work_email
    profile.phone_number = payload.phone_number
    profile.office_location = payload.office_location
    profile.bio = payload.bio

    db.commit()
    db.refresh(profile)

    return {
        "ok": True,
        "msg": "HR profile saved successfully",
    }