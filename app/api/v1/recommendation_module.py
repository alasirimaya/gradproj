import json
import re
import torch
from torch.nn.functional import cosine_similarity


def _to_tensor(embedding):
    if embedding is None:
        return None

    if isinstance(embedding, str):
        embedding = json.loads(embedding)

    return torch.tensor(embedding, dtype=torch.float32)


def _normalize(text):
    return (text or "").lower().replace("-", " ").strip()


def _split_skills(skills_text):
    if not skills_text:
        return set()

    parts = re.split(r"[,;/|\n]+", skills_text)

    return {
        _normalize(skill)
        for skill in parts
        if _normalize(skill)
    }


def _get_user_skills(user):
    skills = set()

    for user_skill in user.skills:
        if user_skill.skill and user_skill.skill.name:
            skills.add(_normalize(user_skill.skill.name))

    return skills


def _get_user_profile_text(user):
    parts = [
        getattr(user, "full_name", ""),
        getattr(user, "education", ""),
        getattr(user, "about", ""),
        getattr(user, "experience", ""),
    ]

    skills_text = ", ".join(_get_user_skills(user))
    parts.append(skills_text)

    return _normalize(" ".join(parts))


def _skill_score(user_skills, job_skills):
    if not job_skills:
        return None

    matched = user_skills.intersection(job_skills)
    return len(matched) / len(job_skills)


def _education_score(user_text, job_text):
    wants_degree = any(word in job_text for word in [
        "bachelor", "degree", "computer science", "information technology"
    ])

    if not wants_degree:
        return None

    has_degree = any(word in user_text for word in [
        "bachelor", "information technology", "computer science", "it"
    ])

    return 1.0 if has_degree else 0.0


def _experience_score(user_text, job_text):
    wants_experience = any(word in job_text for word in [
        "experience", "years"
    ])

    if not wants_experience:
        return None

    has_experience = any(word in user_text for word in [
        "experience", "internship", "developer", "program", "academy"
    ])

    return 1.0 if has_experience else 0.0


def recommend_for_user(user, jobs):
    recommendations = []

    user_skills = _get_user_skills(user)
    user_text = _get_user_profile_text(user)

    user_emb = None
    if user.embedding_data and user.embedding_data.embedding:
        user_emb = _to_tensor(user.embedding_data.embedding)

    for job in jobs:
        job_skills = _split_skills(job.skills)

        job_text = _normalize(
            f"{job.title} {job.company} {job.description} {job.skills}"
        )

        scores = []

        skill_match = _skill_score(user_skills, job_skills)
        if skill_match is not None:
            scores.append(skill_match)

        education_match = _education_score(user_text, job_text)
        if education_match is not None:
            scores.append(education_match)

        experience_match = _experience_score(user_text, job_text)
        if experience_match is not None:
            scores.append(experience_match)

        embedding_score = 0.0
        if user_emb is not None and job.embedding_data and job.embedding_data.embedding:
            job_emb = _to_tensor(job.embedding_data.embedding)

            embedding_score = cosine_similarity(
                user_emb.unsqueeze(0),
                job_emb.unsqueeze(0),
            ).item()

            embedding_score = max(0.0, min(1.0, embedding_score))

        if scores:
            requirements_score = sum(scores) / len(scores)
            similarity = (requirements_score * 0.8) + (embedding_score * 0.2)
        else:
            similarity = embedding_score

        recommendations.append({
            "job_id": job.id,
            "title": job.title,
            "company": job.company,
            "location": job.location,
            "workplace": job.workplace,
            "employment_type": job.employment_type,
            "description": job.description,
            "skills": job.skills,
            "similarity": similarity,
        })

    recommendations.sort(key=lambda x: x["similarity"], reverse=True)

    return recommendations