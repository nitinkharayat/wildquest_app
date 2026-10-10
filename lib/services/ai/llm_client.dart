import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';

abstract class LlmClient {
  bool get isAvailable;
  Future<String> completeJson({required String system, required String prompt});
}

class HttpLlmClient implements LlmClient {
  HttpLlmClient({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  @override
  bool get isAvailable => AppConfig.hasBackend;

  @override
  Future<String> completeJson({required String system, required String prompt}) async {
    if (!isAvailable) throw const LlmUnavailableException('Backend is not configured.');
    final response = await _client.post(
      Uri.parse('${AppConfig.apiBaseUrl}/api/ai/quest'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'system': system, 'prompt': prompt, 'model': AppConfig.gemmaModel}),
    ).timeout(const Duration(seconds: 25));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LlmUnavailableException('AI backend returned ${response.statusCode}.');
    }
    final decoded = jsonDecode(response.body);
    final text = decoded is Map && decoded['content'] is String ? decoded['content'] as String : null;
    if (text == null || text.trim().isEmpty) throw const LlmUnavailableException('Empty AI response.');
    return text;
  }
}

class LlmUnavailableException implements Exception {
  const LlmUnavailableException(this.message);
  final String message;
  @override
  String toString() => 'LlmUnavailableException: $message';
}
