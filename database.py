from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# قاعدة البيانات
DATABASE_URL = "sqlite:///./app.db"

engine = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False}
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# استيراد الموديلات قبل إنشاء الجداول
from models import User, Job, UserEmbedding, JobEmbedding


# إنشاء الجداول إذا لم تكن موجودة
Base.metadata.create_all(bind=engine)

# جلسة قاعدة البيانات
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

