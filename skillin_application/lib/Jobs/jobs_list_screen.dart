/*import 'package:flutter/material.dart';
import 'dummy_jobs.dart';
import 'job_card.dart';
import 'job_details_screen.dart';

class JobsListScreen extends StatelessWidget {
  const JobsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Find Your Job",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search for jobs...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Jobs List
            Expanded(
              child: ListView.builder(
                itemCount: dummyJobs.length,
                itemBuilder: (context, index) {
                  return JobCard(
                    job: dummyJobs[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              JobDetailsScreen(job: dummyJobs[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


*/
/*
import 'package:flutter/material.dart';
import 'job_card.dart';
import 'job_details_screen.dart';
import 'job_model.dart';
import '../services/jobs_service.dart';

class JobsListScreen extends StatefulWidget {
  const JobsListScreen({super.key});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  List<JobModel> jobs = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final response = await JobsService.getJobs();

    if (response["ok"] == true) {
      final List data = response["data"] as List;

      setState(() {
        jobs = data
            .map((job) => JobModel.fromJson(Map<String, dynamic>.from(job)))
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        errorMessage = response["msg"]?.toString() ?? "Failed to load jobs";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Find Your Job",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: fetchJobs,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                )
              : jobs.isEmpty
                  ? const Center(child: Text("No jobs found"))
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: "Search for jobs...",
                                border: InputBorder.none,
                                icon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              itemCount: jobs.length,
                              itemBuilder: (context, index) {
                                final job = jobs[index];

                                return JobCard(
                                  job: job,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            JobDetailsScreen(jobId: job.id),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'filter_screen.dart';
import 'job_card.dart';
import 'job_details_screen.dart';
import 'job_model.dart';
import '../services/jobs_service.dart';

class JobsListScreen extends StatefulWidget {
  const JobsListScreen({super.key});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  List<JobModel> allJobs = [];
  List<JobModel> filteredJobs = [];
  bool isLoading = true;
  String? errorMessage;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController locationController =
      TextEditingController(text: "Riyadh, KSA");

  String selectedJobType = "Full-time";

  @override
  void initState() {
    super.initState();
    fetchJobs();
    searchController.addListener(applyFilters);
  }

  @override
  void dispose() {
    searchController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> fetchJobs() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final response = await JobsService.getJobs();

    if (response["ok"] == true) {
      final List data = response["data"] as List;

      setState(() {
        allJobs = data
            .map((job) => JobModel.fromJson(Map<String, dynamic>.from(job)))
            .toList();
        filteredJobs = List.from(allJobs);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        errorMessage = response["msg"]?.toString() ?? "Failed to load jobs";
      });
    }
  }

  void applyFilters() {
    final query = searchController.text.trim().toLowerCase();

    setState(() {
      filteredJobs = allJobs.where((job) {
        final matchesQuery =
            job.title.toLowerCase().contains(query) ||
            job.company.toLowerCase().contains(query);

        return matchesQuery;
      }).toList();
    });
  }

  Future<void> openFilter() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilterScreen(
          selectedJobType: selectedJobType,
          selectedLocation: locationController.text,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectedJobType = result["jobType"] ?? selectedJobType;
        locationController.text = result["location"] ?? locationController.text;
      });
    }
  }

  String _jobTypePlaceholder(int index) {
    const types = ["Full-time", "Part time", "Remote"];
    return types[index % types.length];
  }

  String _locationPlaceholder(int index) {
    const locations = ["Riyadh, KSA", "Jeddah, KSA", "Dammam, KSA"];
    return locations[index % locations.length];
  }

  String _timeAgoPlaceholder(int index) {
    const times = ["25 minute ago", "1 day ago", "2 days ago"];
    return times[index % times.length];
  }

  Widget _searchHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: const DecorationImage(
          image: AssetImage("assets/images/BackgroundSearch.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFFB5B8C7)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Design",
                      hintStyle: TextStyle(color: Color(0xFFB5B8C7)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFFF4A146)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      hintText: "Riyadh, KSA",
                      hintStyle: TextStyle(color: Color(0xFFB5B8C7)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Expanded(
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F7),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6A6F85),
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _topFilterRow() {
    return Row(
      children: [
        GestureDetector(
          onTap: openFilter,
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1F57),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                "assets/images/forFilter.png",
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.tune,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _chip("IT Supervisor"),
        const SizedBox(width: 10),
        _chip("Designer"),
        const SizedBox(width: 10),
        _chip(selectedJobType),
      ],
    );
  }

  Widget _emptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/noResult.png",
              width: 170,
              height: 170,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.search_off,
                size: 90,
                color: Color(0xFFB0B3C7),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "No results found",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B1F3B),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "The search could not be found, please check spelling or write another word.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6A6F85),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
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
        iconTheme: const IconThemeData(color: Color(0xFF1B1F3B)),
        title: const Text(
          "Search",
          style: TextStyle(color: Color(0xFF1B1F3B)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(errorMessage!, textAlign: TextAlign.center),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _searchHeader(),
                      const SizedBox(height: 18),
                      _topFilterRow(),
                      const SizedBox(height: 18),
                      filteredJobs.isEmpty
                          ? _emptyState()
                          : Expanded(
                              child: ListView.builder(
                                itemCount: filteredJobs.length,
                                itemBuilder: (context, index) {
                                  final job = filteredJobs[index];

                                  return JobCard(
  job: job,
  location: "Riyadh, KSA",
  jobType: "Full Time",
  timeAgo: "1 day ago",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailsScreen(jobId: job.id),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
    );
  }
}