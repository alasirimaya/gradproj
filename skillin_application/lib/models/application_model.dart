/*class ApplicationModel {

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
*/
class ApplicationModel {
  final int id;
  final int jobId;
  final int userId;
  final String jobTitle;
  final String company;
  final String status;
  final String info;
  final String cvFilename;

  ApplicationModel({
    this.id = 0,
    this.jobId = 0,
    this.userId = 0,
    required this.jobTitle,
    required this.company,
    required this.status,
    this.info = "",
    this.cvFilename = "",
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json["id"] ?? 0,
      jobId: json["job_id"] ?? 0,
      userId: json["user_id"] ?? 0,
      jobTitle: json["job_title"] ?? "",
      company: json["company"] ?? "",
      status: json["status"] ?? "Under Review",
      info: json["info"] ?? "",
      cvFilename: json["cv_filename"] ?? "",
    );
  }
}