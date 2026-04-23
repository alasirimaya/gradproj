import json
from app.api.v1.embeddings_module import get_user_embedding, get_job_embedding
from models import UserEmbedding, JobEmbedding


def save_user_embedding(db, user):
    emb = get_user_embedding(user).tolist()
    emb_json = json.dumps(emb)

    existing = db.query(UserEmbedding).filter_by(user_id=user.id).first()

    if existing:
        existing.embedding = emb_json
    else:
        db_emb = UserEmbedding(user_id=user.id, embedding=emb_json)
        db.add(db_emb)

    db.commit()


def save_job_embedding(db, job):
    emb = get_job_embedding(job).tolist()
    emb_json = json.dumps(emb)

    existing = db.query(JobEmbedding).filter_by(job_id=job.id).first()

    if existing:
        existing.embedding = emb_json
    else:
        db_emb = JobEmbedding(job_id=job.id, embedding=emb_json)
        db.add(db_emb)

    db.commit()