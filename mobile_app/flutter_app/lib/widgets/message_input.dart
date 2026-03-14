import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {

  final Function(String) onSend;

  MessageInput({required this.onSend});

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {

  final controller = TextEditingController();

  void send(){

    if(controller.text.trim().isEmpty) return;

    widget.onSend(controller.text);

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(10),

      child: Row(
        children: [

          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Ask something...",
              ),

              // 👇 ENTER press hone par message send
              onSubmitted: (value) {
                send();
              },

            ),
          ),

          IconButton(
            icon: Icon(Icons.send),
            onPressed: send,
          )

        ],
      ),
    );
  }
}