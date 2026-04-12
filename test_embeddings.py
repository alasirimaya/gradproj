from database import SessionLocal
from models import User, Job
from app.api.v1.embeddings_module import get_user_embedding, get_job_embedding

def test_embeddings():
    db = SessionLocal()

    # جلب أول مستخدم
    user = db.query(User).first()
    # جلب أول وظيفة
    job = db.query(Job).first()

    if not user or not job:
        print("لا يوجد User أو Job في قاعدة البيانات للاختبار.")
        return

    user_emb = get_user_embedding(user)
    job_emb = get_job_embedding(job)

    print("User Embedding shape:", user_emb.shape)
    print("Job Embedding shape:", job_emb.shape)

    print("أول 5 قيم من User Embedding:", user_emb[:5])
    print("أول 5 قيم من Job Embedding:", job_emb[:5])

if __name__ == "__main__":
    test_embeddings()
