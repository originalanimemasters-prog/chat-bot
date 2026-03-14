import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input.dart';

class ChatScreen extends StatefulWidget {

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<Map<String,String>> messages = [];

  void sendMessage(String text) async {

    setState(() {
      messages.add({"role":"user","text":text});
    });

    String reply = await ApiService.sendMessage(text);

    setState(() {
      messages.add({"role":"ai","text":reply});
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("AI Assistant"),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context,index){

                final msg = messages[index];

                return ChatBubble(
                  text: msg["text"]!,
                  isUser: msg["role"]=="user",
                );
              },
            ),
          ),

          MessageInput(onSend: sendMessage),

        ],
      ),
    );
  }
}