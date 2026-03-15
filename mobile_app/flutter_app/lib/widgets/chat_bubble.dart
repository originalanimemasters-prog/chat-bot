import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:highlight/languages/python.dart';

class ChatBubble extends StatelessWidget {

  final String text;
  final bool isUser;

  ChatBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        constraints: BoxConstraints(maxWidth: 650),
        padding: EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
        ),

        child: MarkdownBody(

          data: text,

          selectable: true,

          builders: {

            "code": CodeElementBuilder(),

          },

        ),
      ),
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {

  @override
  Widget visitElementAfter(element, preferredStyle) {

    final code = element.textContent;

    return Container(

      width: double.infinity,

      child: HighlightView(
        code,
        language: "python",
        padding: EdgeInsets.all(10),

        textStyle: TextStyle(
          fontFamily: "monospace",
          fontSize: 14,
        ),
      ),
    );
  }
}