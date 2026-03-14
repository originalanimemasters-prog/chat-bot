import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Assistant',

      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),

      home: ChatScreen(),
    );
  }
}