import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/app_error.dart';

class ProfileService {
  static const String _baseUrl = "http://127.0.0.1:8000";
  static final ApiClient _api = ApiClient(baseUrl: _baseUrl);

  static Future<Map<String, dynamic>> saveProfile({
    required int userId,
    required String fullName,
    required List<String> skills,
  }) async {
    final token = await AuthService.getToken();

    try {
      await _api.postJson(
        "/api/v1/profile/save",
        token: token,
        body: {
          "user_id": userId,
          "full_name": fullName,
          "skills": skills,
        },
      );

      return {"ok": true};
    } catch (e) {
      print("SAVE PROFILE ERROR: $e");

      final msg = e is AppError ? e.message : "Failed to save profile";
      final status = e is AppError ? e.statusCode : null;

      return {"ok": false, "msg": msg, "status": status};
    }
  }
}