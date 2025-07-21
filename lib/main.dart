import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yusuf_flutter_test_p1/pages/sign_in_screen.dart';
import 'package:yusuf_flutter_test_p1/widgets/chat_widget.dart';
import 'package:yusuf_flutter_test_p1/pages/jarvis_chat_screen.dart';
import 'package:yusuf_flutter_test_p1/pages/saved_chats.dart';

void main() async{
  await _setup();
  runApp(MaterialApp(home: SignInPage()));
}

Future<void> _setup() async {
  await dotenv.load(
    fileName: ".env"
    );
}
