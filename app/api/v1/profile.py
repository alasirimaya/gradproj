from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from database import get_db
from models import User, Skill, UserSkill
from auth.router import get_current_user
from auth.schemas import UpdateSkillsRequest
from app.api.v1.embedding_service import save_user_embedding

router = APIRouter(tags=["Profile"])


@router.post("/skills")
def update_skills(
    payload: UpdateSkillsRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # 🧹 delete old skills
    db.query(UserSkill).filter(UserSkill.user_id == current_user.id).delete()

    # ➕ add new skills
    for skill_name in payload.skills:
        skill_name = skill_name.strip().lower()

        skill = db.query(Skill).filter(Skill.name == skill_name).first()

        if not skill:
            skill = Skill(name=skill_name)
            db.add(skill)
            db.commit()
            db.refresh(skill)

        user_skill = UserSkill(user_id=current_user.id, skill_id=skill.id)
        db.add(user_skill)

    db.commit()

    # 🔄 refresh user to get new skills
    db.refresh(current_user)

    # 🔥 regenerate embedding
    save_user_embedding(db, current_user)

    return {"message": "Skills updated successfully"}