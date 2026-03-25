class ApplicationModel {

  final String jobTitle;
  final String company;
  final String status;

  ApplicationModel({

    required this.jobTitle,
    required this.company,
    required this.status,

  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {

    return ApplicationModel(

      jobTitle: json["job_title"] ?? "",
      company: json["company"] ?? "",
      status: json["status"] ?? "Under Review",

    );

  }

}