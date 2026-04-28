import 'package:flutter/material.dart';
import 'package:skillin_application/services/auth_service.dart';
import 'package:skillin_application/auth/login_screen.dart';
import 'package:skillin_application/main_navigation_screen.dart';
import 'package:skillin_application/hr/hr_navigation_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: AuthService.getMe(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data?["ok"] != true) {
          return const LoginScreen();
        }

        final data = snapshot.data!["data"];
        final role = (data["role"] ?? "personal").toString();

        if (role == "business") {
          return const HrNavigationScreen();
        }

        return const MainNavigationScreen();
      },
    );
  }
}