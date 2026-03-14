import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {

  final String text;
  final bool isUser;

  ChatBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.all(10),

      child: Container(
        padding: EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),

        child: Text(text),
      ),
    );
  }
}