import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../auth/auth_gate.dart';
import '../Jobs/job_details_screen.dart';
import '../Jobs/job_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // زر الذهاب للملف الشخصي
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: const Text("Go to Profile"),
            ),

            const SizedBox(height: 20),

            // زر تسجيل الخروج
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthGate()),
                );
              },
              child: const Text("Logout"),
            ),

            const SizedBox(height: 20),

            // زر اختبار صفحة تفاصيل الوظيفة
            ElevatedButton(
              onPressed: () {
                Job testJob = Job(
                  title: "Test Job",
                  company: "Test Company",
                  location: "Riyadh",
                  jobType: "Full Time",
                  salary: "10,000 SAR",
                  description: "This is a test job description.",
                  skills: ["Skill 1", "Skill 2"],
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JobDetailsScreen(job: testJob),
                  ),
                );
              },
              child: const Text(" Job Details"),
            ),
          ],
        ),
      ),
    );
  }
}


