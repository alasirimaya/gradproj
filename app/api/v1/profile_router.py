from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from models import User, Skill, UserSkill

router = APIRouter(
    prefix="/profile",
    tags=["Profile"]
)

@router.post("/save")
def save_profile(
    user_id: int,
    full_name: str,
    skills: list[str] = [],
    db: Session = Depends(get_db)
):
    user = db.query(User).filter(User.id == user_id).first()

    if not user:
        return {"ok": False, "msg": "User not found"}

    user.full_name = full_name

    db.query(UserSkill).filter(UserSkill.user_id == user_id).delete()

    for skill_name in skills:
        skill = db.query(Skill).filter(Skill.name == skill_name).first()

        if not skill:
            skill = Skill(name=skill_name)
            db.add(skill)
            db.commit()
            db.refresh(skill)

        user_skill = UserSkill(
            user_id=user_id,
            skill_id=skill.id
        )
        db.add(user_skill)

    db.commit()

    return {"ok": True}