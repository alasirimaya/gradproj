import 'package:flutter/material.dart';
import 'package:skillin_application/services/jobs_service.dart';
import 'package:skillin_application/services/application_service.dart';

class HrPostedJobsScreen extends StatefulWidget {
  const HrPostedJobsScreen({super.key});

  @override
  State<HrPostedJobsScreen> createState() => _HrPostedJobsScreenState();
}

class _HrPostedJobsScreenState extends State<HrPostedJobsScreen> {
  bool isLoading = true;

  List jobs = [];
  Map<int, List<dynamic>> applicantsByJob = {};
  Set<int> expandedJobs = {};

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    final response = await JobsService.getJobs();

    if (!mounted) return;

    if (response["ok"] == true) {
      jobs = response["data"] as List;

      for (final item in jobs) {
        final job = Map<String, dynamic>.from(item);
        final jobId = job["id"];

        if (jobId != null) {
          final applicantsResponse =
              await JobsService.getApplicantsByJobId(jobId);

          if (applicantsResponse["ok"] == true) {
            applicantsByJob[jobId] =
                applicantsResponse["data"] as List<dynamic>;
          } else {
            applicantsByJob[jobId] = [];
          }
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _updateStatus(
    int applicationId,
    String status,
  ) async {
    final response = await ApplicationService.updateApplicationStatus(
      applicationId: applicationId,
      status: status,
    );

    if (response["ok"] == true) {
      await _loadJobs();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Application marked as $status"),
        ),
      );
    }
  }

  Widget _applicantCard(Map<String, dynamic> applicant) {
    final applicationId = applicant["id"];
    final status = applicant["status"]?.toString() ?? "Under Review";

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      applicant["applicant_name"]?.toString() ??
                          "Unknown User",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF1B1F3B),
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      applicant["applicant_email"]?.toString() ?? "",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6A6F85),
                      ),
                    ),

                    if ((applicant["cv_filename"] ?? "")
                        .toString()
                        .isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          "CV: ${applicant["cv_filename"]}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6A6F85),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _statusBgColor(status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      status,
                      style: TextStyle(
                        color: _statusColor(status),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (status == "Under Review") ...[
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _updateStatus(
                        applicationId,
                        "Accepted",
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _updateStatus(
                        applicationId,
                        "Rejected",
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Reject",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _jobCard(Map<String, dynamic> job) {
    final int jobId = job["id"];
    final applicants = applicantsByJob[jobId] ?? [];
    final isExpanded = expandedJobs.contains(jobId);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job["title"]?.toString() ?? "",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B1F3B),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            job["company"]?.toString() ?? "",
            style: const TextStyle(
              color: Color(0xFF6A6F85),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            job["description"]?.toString() ?? "",
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6A6F85),
            ),
          ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedJobs.remove(jobId);
                } else {
                  expandedJobs.add(jobId);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFD8E3FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                "Applicants (${applicants.length})",
                style: const TextStyle(
                  color: Color(0xFF3866FA),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          if (isExpanded) ...[
            const SizedBox(height: 14),

            if (applicants.isEmpty)
              const Text(
                "No applicants yet.",
                style: TextStyle(
                  color: Color(0xFF6A6F85),
                ),
              )
            else
              ...applicants.map((item) {
                final applicant =
                    Map<String, dynamic>.from(item);

                return _applicantCard(applicant);
              }).toList(),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    if (status == "Accepted") return Colors.green;
    if (status == "Rejected") return Colors.red;
    return Colors.orange;
  }

  Color _statusBgColor(String status) {
    if (status == "Accepted") {
      return Colors.green.withOpacity(0.12);
    }

    if (status == "Rejected") {
      return Colors.red.withOpacity(0.12);
    }

    return Colors.orange.withOpacity(0.12);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6FB),
        elevation: 0,
        title: const Text(
          "Posted Jobs",
          style: TextStyle(
            color: Color(0xFF1B1F3B),
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : jobs.isEmpty
              ? const Center(
                  child: Text("No posted jobs yet."),
                )
              : RefreshIndicator(
                  onRefresh: _loadJobs,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job =
                          Map<String, dynamic>.from(jobs[index]);

                      return _jobCard(job);
                    },
                  ),
                ),
    );
  }
}