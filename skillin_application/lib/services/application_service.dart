/*import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:skillin_application/models/application_model.dart';

class ApplicationService {
static const String baseUrl =
"http://localhost:8000/api/v1";

  static Future<List<ApplicationModel>> fetchApplications() async {

    final response = await http.get(
      Uri.parse("$baseUrl/applications"),
    );

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      return data
          .map((json) => ApplicationModel.fromJson(json))
          .toList();

    } else {

      throw Exception("Failed to load applications");

    }

  }

}
*/
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:skillin_application/models/application_model.dart';

class ApplicationService {
  static const String baseUrl = "http://localhost:8000/api/v1";

  static final List<ApplicationModel> _localApplications = [];

  static Future<List<ApplicationModel>> fetchApplications() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/applications"),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        final apiApplications = data
            .map((json) => ApplicationModel.fromJson(json))
            .toList();

        return [..._localApplications, ...apiApplications];
      } else {
        return [..._localApplications];
      }
    } catch (_) {
      return [..._localApplications];
    }
  }

  static void addLocalApplication(ApplicationModel application) {
    _localApplications.insert(0, application);
  }
}