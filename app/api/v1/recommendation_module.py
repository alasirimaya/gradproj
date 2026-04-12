import torch
from sentence_transformers import util

def recommend_for_user(user, jobs):
    # نجيب embedding حق المستخدم من قاعدة البيانات
    user_emb = torch.tensor(user.embedding_data.embedding)

    recommendations = []

    for job in jobs:
        # لو الوظيفة ما عندها embedding نتجاوزها
        if not job.embedding_data:
            continue

        # نجيب embedding الوظيفة من قاعدة البيانات
        job_emb = torch.tensor(job.embedding_data.embedding)

        # نحسب التشابه
        similarity = float(util.cos_sim(user_emb, job_emb)[0][0])

        recommendations.append({
            "job_id": job.id,
            "title": job.title,
            "company": job.company,
            "similarity": round(similarity, 4)
        })

    # نرتّب النتائج من الأعلى للأقل
    recommendations.sort(key=lambda x: x["similarity"], reverse=True)
    return recommendations


