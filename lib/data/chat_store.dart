import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:yusuf_flutter_test_p1/models/chat_models.dart';
import '../models/chat_session.dart';

class ChatStore {
  ChatStore({required String? uid}) : _key = 'saved_chat_sessions_${uid ?? 'guest'}';
  final String _key;

  Future<List<ChatSession>> all() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List)
        .map((e) => ChatSession.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return list;
  }

  Future<void> _write(List<ChatSession> sessions) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_key, jsonEncode(sessions.map((e) => e.toJson()).toList()));
  }

  Future<void> saveSession({
    required String title,
    required List<ChatMessage> messages,
  }) async {

    final chron = messages.reversed
        .map((m) => ChatMsg.fromChatMessage(m))
        .toList();

    final session = ChatSession(
      id: const Uuid().v4(),
      title: title.trim().isEmpty ? 'Conversation' : title.trim(),
      createdAt: DateTime.now(),
      messages: chron,
    );

    final sessions = await all();
    sessions.insert(0, session); 
    await _write(sessions);
  }

  Future<void> renameSession(String id, String newTitle) async {
    final sessions = await all();
    final idx = sessions.indexWhere((s) => s.id == id);
    if (idx != -1) {
      sessions[idx].title = newTitle.trim().isEmpty ? 'Conversation' : newTitle.trim();
      await _write(sessions);
    }
  }

  Future<void> deleteSession(String id) async {
    final sessions = await all();
    sessions.removeWhere((s) => s.id == id);
    await _write(sessions);
  }

  Future<void> deleteMany(Iterable<String> ids) async {
    final sessions = await all();
    sessions.removeWhere((s) => ids.contains(s.id));
    await _write(sessions);
  }

  Future<ChatSession?> getById(String id) async {
    final sessions = await all();
    try {
      return sessions.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_key);
  }
}
