from app.api.v1.embeddings_module import get_user_embedding, get_job_embedding
from models import UserEmbedding, JobEmbedding

def save_user_embedding(db, user):
    emb = get_user_embedding(user).tolist()

    existing = db.query(UserEmbedding).filter_by(user_id=user.id).first()

    if existing:
        existing.embedding = emb
    else:
        db_emb = UserEmbedding(user_id=user.id, embedding=emb)
        db.add(db_emb)

    db.commit()


def save_job_embedding(db, job):
    emb = get_job_embedding(job).tolist()

    existing = db.query(JobEmbedding).filter_by(job_id=job.id).first()

    if existing:
        existing.embedding = emb
    else:
        db_emb = JobEmbedding(job_id=job.id, embedding=emb)
        db.add(db_emb)

    db.commit()
