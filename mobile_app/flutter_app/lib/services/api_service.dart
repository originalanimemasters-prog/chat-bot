import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static String baseUrl = "http://localhost:8000";

  static Future<int> createNewChat() async {

    final res = await http.post(Uri.parse("$baseUrl/new_chat"));

    return jsonDecode(res.body)["chat_id"];
  }

  static Future<List<dynamic>> getChats() async {

    final res = await http.get(Uri.parse("$baseUrl/chats"));

    return jsonDecode(res.body);
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

}