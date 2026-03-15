import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static String baseUrl = "http://localhost:8000";

  static Future<int> createNewChat() async {

    final res = await http.post(
      Uri.parse("$baseUrl/new_chat")
    );

    return jsonDecode(res.body)["chat_id"];
  }

  static Future<String> sendMessage(int chatId, String message) async {

    final res = await http.post(
      Uri.parse("$baseUrl/chat"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({
        "chat_id": chatId,
        "message": message
      })
    );

    return jsonDecode(res.body)["reply"];
  }

  static Future renameChat(int id, String title) async {

    await http.put(
      Uri.parse("$baseUrl/rename_chat/$id?title=$title")
    );
  }

  static Future deleteChat(int id) async {

    await http.delete(
      Uri.parse("$baseUrl/delete_chat/$id")
    );
  }

  static Stream<String> streamMessage(int chatId, String message) async* {

    var request = http.Request(
      "POST",
      Uri.parse("$baseUrl/chat_stream"),
    );

    request.headers["Content-Type"] = "application/json";

    request.body = jsonEncode({
      "chat_id": chatId,
      "message": message
    });

    var response = await request.send();

    await for (var chunk in response.stream.transform(utf8.decoder)) {
      yield chunk;
    }
  }

}