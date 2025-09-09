// lib/state/providers.dart
import 'package:flutter/material.dart'; // ThemeMode
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yusuf_flutter_test_p1/models/chat_models.dart';
import '../widgets/Auth/auth_service.dart';
import '../data/chat_store.dart';
import '../models/chat_session.dart';

/// Firebase core instances
final firebaseAuthProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

/// Auth service via DI
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(firebaseAuthProvider));
});

/// Stream of the current user (null when signed out)
final authStateProvider = StreamProvider<User?>(
  // Use idTokenChanges for reliable initial + post-login emissions
  (ref) => ref.watch(firebaseAuthProvider).idTokenChanges(),
);

/// Current uid string (null when signed out)
final currentUserIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(authStateProvider);
  return auth.asData?.value?.uid;
});

/// Namespaced ChatStore per uid
final chatStoreProvider = Provider<ChatStore>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  return ChatStore(uid: uid);
});

final currentChatProvider =
    StateNotifierProvider<CurrentChatNotifier, List<ChatMessage>>((ref) {
  return CurrentChatNotifier();
});

class CurrentChatNotifier extends StateNotifier<List<ChatMessage>> {
  CurrentChatNotifier() : super(const []);

  void add(ChatMessage m) => state = [m, ...state];
  void addAllAtTop(List<ChatMessage> ms) => state = [...ms, ...state];
  void clear() => state = const [];
}

/// Saved sessions list provider (backed by ChatStore)
final chatSessionsProvider =
    StateNotifierProvider<ChatSessionsNotifier, List<ChatSession>>((ref) {
  return ChatSessionsNotifier(ref.watch(chatStoreProvider));
});

class ChatSessionsNotifier extends StateNotifier<List<ChatSession>> {
  ChatSessionsNotifier(this._store) : super(const []) {
    refresh();
  }
  final ChatStore _store;

  Future<void> refresh() async {
    state = await _store.all();
  }

  Future<void> saveSession({
    required String title,
    required List<ChatMessage> messages,
  }) async {
    await _store.saveSession(title: title, messages: messages);
    await refresh();
  }

  Future<void> rename(String id, String title) async {
    await _store.renameSession(id, title);
    await refresh();
  }

  Future<void> deleteOne(String id) async {
    await _store.deleteSession(id);
    await refresh();
  }

  Future<void> deleteMany(Iterable<String> ids) async {
    await _store.deleteMany(ids);
    await refresh();
  }
}

/// THEME MODE (Light/Dark) — persisted with SharedPreferences
final themeModeProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) => ThemeModeController(),
);

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.light) {
    _load(); // load persisted choice on startup
  }

  static const _prefKey = 'theme_mode';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);
    if (raw == null) return; // keep default if nothing saved yet
    state = _fromString(raw);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, _toString(state));
  }

  /// Set an explicit ThemeMode
  void setMode(ThemeMode mode) {
    state = mode;
    _save();
  }

  /// true -> Light, false -> Dark
  void setLight(bool isLight) {
    state = isLight ? ThemeMode.light : ThemeMode.dark;
    _save();
  }

  bool get isLight => state == ThemeMode.light;

  // Helpers to persist/restore
  static String _toString(ThemeMode m) =>
      m == ThemeMode.light ? 'light' : (m == ThemeMode.dark ? 'dark' : 'system');

  static ThemeMode _fromString(String s) =>
      s == 'light' ? ThemeMode.light : (s == 'dark' ? ThemeMode.dark : ThemeMode.system);
}
