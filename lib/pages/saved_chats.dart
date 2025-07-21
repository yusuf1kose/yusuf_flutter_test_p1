import 'package:flutter/material.dart';

class SavedChats extends StatefulWidget {
  const SavedChats({super.key});

  @override
  State<SavedChats> createState() {
    return _SavedChatsState();
  }
}

class _SavedChatsState extends State<SavedChats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Action area'),
          Text('The chats'),
        ],
      ),

    );
    
  }
}