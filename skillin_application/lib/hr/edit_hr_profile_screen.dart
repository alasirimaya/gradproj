import 'package:flutter/material.dart';
import 'package:skillin_application/services/auth_service.dart';
import 'package:skillin_application/services/api_client.dart';

class EditHrProfileScreen extends StatefulWidget {
  const EditHrProfileScreen({super.key});

  @override
  State<EditHrProfileScreen> createState() => _EditHrProfileScreenState();
}

class _EditHrProfileScreenState extends State<EditHrProfileScreen> {
  static const Color pageBg = Color(0xFFF5F6FA);
  static const Color darkBlueText = Color(0xFF150B3D);

  bool _loading = true;
  bool _saving = false;

  final TextEditingController _profilePictureController =
      TextEditingController();

  final TextEditingController _fullNameController =
      TextEditingController();

  final TextEditingController _jobTitleController =
      TextEditingController();

  final TextEditingController _workEmailController =
      TextEditingController();

  final TextEditingController _phoneNumberController =
      TextEditingController();

  final TextEditingController _officeLocationController =
      TextEditingController();

  final TextEditingController _bioController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHrProfile();
  }

  Future<void> _loadHrProfile() async {
    try {
      final token = await AuthService.getToken();

      final data = await ApiClient(
        baseUrl: "http://127.0.0.1:8000",
      ).getJson<Map<String, dynamic>>(
        "/api/v1/hr-profile/me",
        token: token,
        parser: (json) => (json as Map).cast<String, dynamic>(),
      );

      _profilePictureController.text =
          data["profile_picture"] ?? "";

      _fullNameController.text =
          data["full_name"] ?? "";

      _jobTitleController.text =
          data["job_title"] ?? "";

      _workEmailController.text =
          data["work_email"] ?? "";

      _phoneNumberController.text =
          data["phone_number"] ?? "";

      _officeLocationController.text =
          data["office_location"] ?? "";

      _bioController.text =
          data["bio"] ?? "";
    } catch (e) {
      debugPrint("LOAD HR PROFILE ERROR: $e");
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
    });
  }

  Future<void> _saveHrProfile() async {
    setState(() {
      _saving = true;
    });

    try {
      final token = await AuthService.getToken();

      await ApiClient(
        baseUrl: "http://127.0.0.1:8000",
      ).postJson(
        "/api/v1/hr-profile/save",
        token: token,
        body: {
          "profile_picture":
              _profilePictureController.text.trim(),

          "full_name":
              _fullNameController.text.trim(),

          "job_title":
              _jobTitleController.text.trim(),

          "work_email":
              _workEmailController.text.trim(),

          "phone_number":
              _phoneNumberController.text.trim(),

          "office_location":
              _officeLocationController.text.trim(),

          "bio":
              _bioController.text.trim(),
        },
      );

      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "HR profile saved successfully.",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error saving HR profile: $e",
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _profilePictureController.dispose();
    _fullNameController.dispose();
    _jobTitleController.dispose();
    _workEmailController.dispose();
    _phoneNumberController.dispose();
    _officeLocationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _field({
    required String title,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: _fieldDecoration(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: pageBg,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: pageBg,
        elevation: 0,
        foregroundColor: darkBlueText,
        title: const Text(
          "Edit HR Profile",
        ),
        actions: [
          TextButton(
            onPressed:
                _saving ? null : _saveHrProfile,
            child: Text(
              _saving
                  ? "Saving..."
                  : "Save",
              style: const TextStyle(
                color: Color(0xFFFF9228),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _field(
                title:
                    "Profile picture path or URL",
                controller:
                    _profilePictureController,
              ),
              _field(
                title: "Full name",
                controller:
                    _fullNameController,
              ),
              _field(
                title: "Job title",
                controller:
                    _jobTitleController,
              ),
              _field(
                title: "Work email",
                controller:
                    _workEmailController,
              ),
              _field(
                title: "Phone number",
                controller:
                    _phoneNumberController,
              ),
              _field(
                title: "Office location",
                controller:
                    _officeLocationController,
              ),
              _field(
                title:
                    "Short bio / introduction",
                controller:
                    _bioController,
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}