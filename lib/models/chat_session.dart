import 'dart:convert';

import 'package:yusuf_flutter_test_p1/models/chat_models.dart';


const assistantUserId = 'jarvis';

class ChatMsg {
  final String role; 
  final String text;
  final DateTime ts;

  ChatMsg({required this.role, required this.text, required this.ts});

  factory ChatMsg.fromChatMessage(ChatMessage m) => ChatMsg(
        role: m.user.id == assistantUserId ? 'assistant' : 'user', 
        text: m.text,
        ts: m.createdAt,
      );

  ChatMessage toChatMessage(ChatUser user, ChatUser assistant) => ChatMessage(
        user: role == 'assistant' ? assistant : user,
        text: text,
        createdAt: ts,
      );

  Map<String, dynamic> toJson() =>
      {'role': role, 'text': text, 'ts': ts.toIso8601String()};

  factory ChatMsg.fromJson(Map<String, dynamic> j) => ChatMsg(
        role: j['role'] as String,
        text: j['text'] as String,
        ts: DateTime.parse(j['ts'] as String),
      );
}

class ChatSession {
  final String id;
  String title;
  final DateTime createdAt;
  final List<ChatMsg> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatSession.fromJson(Map<String, dynamic> j) => ChatSession(
        id: j['id'] as String,
        title: j['title'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        messages: (j['messages'] as List)
            .map((e) => ChatMsg.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );

  String encode() => jsonEncode(toJson());
  factory ChatSession.decode(String raw) =>
      ChatSession.fromJson(jsonDecode(raw));
}
