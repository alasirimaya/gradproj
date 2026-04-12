import 'saved_job_model.dart';

class SavedJobsProvider {
  static final List<SavedJobModel> _savedJobs = [];

  static List<SavedJobModel> get savedJobs => List.unmodifiable(_savedJobs);

  static bool isSaved(int jobId) {
    return _savedJobs.any((job) => job.id == jobId);
  }

  static void toggleSaved(SavedJobModel job) {
    final exists = _savedJobs.any((item) => item.id == job.id);

    if (exists) {
      _savedJobs.removeWhere((item) => item.id == job.id);
    } else {
      _savedJobs.add(job);
    }
  }
}