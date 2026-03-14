import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static int chatId = 1;

  static Future<String> sendMessage(String message) async {

    final response = await http.post(
      Uri.parse("http://localhost:8000/chat"),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "chat_id": chatId,
        "message": message
      }),
    );

    final data = jsonDecode(response.body);

    return data["reply"];
  }

}