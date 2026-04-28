import 'package:flutter/material.dart';
import 'package:skillin_application/services/jobs_service.dart';

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
            applicantsByJob[jobId] = applicantsResponse["data"] as List;
          } else {
            applicantsByJob[jobId] = [];
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _applicantCard(Map<String, dynamic> applicant) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            child: Icon(Icons.person),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  applicant["applicant_name"]?.toString() ?? "Unknown User",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1F3B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  applicant["applicant_email"]?.toString() ?? "",
                  style: const TextStyle(
                    color: Color(0xFF6A6F85),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Status: ${applicant["status"]?.toString() ?? "Under Review"}",
                  style: const TextStyle(
                    color: Color(0xFFFF9228),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if ((applicant["cv_filename"]?.toString() ?? "").isNotEmpty)
                  Text(
                    "CV: ${applicant["cv_filename"]}",
                    style: const TextStyle(
                      color: Color(0xFF6A6F85),
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
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
        borderRadius: BorderRadius.circular(20),
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
          const SizedBox(height: 8),
          Text(
            job["description"]?.toString() ?? "",
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6A6F85),
            ),
          ),
          const SizedBox(height: 14),
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFD8E3FF),
                borderRadius: BorderRadius.circular(12),
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
            const SizedBox(height: 12),
            if (applicants.isEmpty)
              const Text(
                "No applicants yet.",
                style: TextStyle(color: Color(0xFF6A6F85)),
              )
            else
              ...applicants.map((item) {
                final applicant = Map<String, dynamic>.from(item);
                return _applicantCard(applicant);
              }).toList(),
          ],
        ],
      ),
    );
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
          style: TextStyle(color: Color(0xFF1B1F3B)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
              ? const Center(child: Text("No posted jobs yet."))
              : RefreshIndicator(
                  onRefresh: _loadJobs,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = Map<String, dynamic>.from(jobs[index]);
                      return _jobCard(job);
                    },
                  ),
                ),
    );
  }
}