from sentence_transformers import SentenceTransformer

# تحميل نموذج SBERT مرة واحدة فقط
model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")


def prepare_user_text(user):
    """
    تجهيز نص المستخدم لاستخدامه في SBERT.
    يعتمد على:
    - اسم المستخدم
    - مهاراته
    """
    skills = ", ".join([s.skill.name for s in user.skills])
    text = f"{user.full_name}. Skills: {skills}"
    return text


def prepare_job_text(job):
    """
    تجهيز نص الوظيفة لاستخدامه في SBERT.
    يعتمد على:
    - عنوان الوظيفة
    - اسم الشركة
    - المهارات المطلوبة
    """
    text = f"{job.title}. {job.company}. Skills: {job.skills}"
    return text


def get_user_embedding(user):
    """
    توليد Embedding لمستخدم واحد.
    """
    text = prepare_user_text(user)
    embedding = model.encode(text, convert_to_tensor=True)
    return embedding


def get_job_embedding(job):
    """
    توليد Embedding لوظيفة واحدة.
    """
    text = prepare_job_text(job)
    embedding = model.encode(text, convert_to_tensor=True)
    return embedding

