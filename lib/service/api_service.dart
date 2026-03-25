import 'dart:convert';
import 'package:chat_bot/model/generated_task_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "https://api.groq.com/openai/v1";
  static const apiKey = "";

  Future<GenerateTaskResponse?> generateTasks(Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/responses"), // Assuming standard OpenAI-compatible endpoint
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print("API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        return GenerateTaskResponse.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print("Error in generateTasks: $e");
      return null;
    }
  }
}
