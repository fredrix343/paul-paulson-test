import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey = 'YOUR-KEY-HERE';
  final String apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> getChatbotResponse(String userInput) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': userInput},
        ],
        'temperature': 0.7,
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String botMessage =
          responseData['choices'][0]['message']['content'];
      return botMessage.trim();
    } else {
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      throw Exception('Failed to load response from OpenAI');
    }
  }
}
