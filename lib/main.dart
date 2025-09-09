// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusuf_flutter_test_p1/theme/app_theme.dart';
import 'package:yusuf_flutter_test_p1/widgets/Auth/auth_gate.dart';
import 'package:yusuf_flutter_test_p1/state/providers.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userThemeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authStateProvider);
    
    final effectiveThemeMode = authState.asData?.value != null 
        ? userThemeMode 
        : ThemeMode.light;
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: effectiveThemeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const AuthGate(),
    );
  }
}