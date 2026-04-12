class JobModel {
  final int id;
  final String title;
  final String company;
  final String description;
  final String skills;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.skills,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? 0,
      title: (json['title'] ?? '').toString(),
      company: (json['company'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      skills: (json['skills'] ?? '').toString(),
    );
  }
}
