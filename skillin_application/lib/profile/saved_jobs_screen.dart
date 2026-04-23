import 'package:flutter/material.dart';
import '../Jobs/jobs_list_screen.dart';
import 'saved_jobs_provider.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  @override
  Widget build(BuildContext context) {
    final jobs = SavedJobsProvider.savedJobs;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Saved Jobs",
          style: TextStyle(color: Color(0xFF1B1F3B)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1B1F3B)),
      ),
      body: jobs.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/nosavedjobs.png",
                      width: 220,
                      height: 220,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.bookmark_border,
                        size: 100,
                        color: Color(0xFFB0B3C7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "No Savings",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B1F3B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "You don't have any jobs saved, please find it in search to save jobs",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6A6F85),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F1F57),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const JobsListScreen(
                                useRecommendations: false,
                                initialJobType: "All Jobs",
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "FIND A JOB",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x11000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7DBFF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.business_center,
                          color: Color(0xFF1B1F3B),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1B1F3B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${job.company} • ${job.location}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6A6F85),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F1F7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                job.jobType,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6A6F85),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}