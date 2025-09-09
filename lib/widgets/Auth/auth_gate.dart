import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yusuf_flutter_test_p1/pages/jarvis_chat_screen.dart';
import 'package:yusuf_flutter_test_p1/pages/sign_in_screen.dart';
import 'package:yusuf_flutter_test_p1/state/providers.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    print('AuthGate build called'); // Debug log

    return auth.when(
      loading: () {
        print('AuthGate: loading state'); // Debug log
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (e, _) {
        print('AuthGate: error state - $e'); // Debug log
        return Scaffold(
          body: Center(child: Text('Auth error: $e')),
        );
      },
      data: (user) {
        print('AuthGate: data state - user: ${user?.uid ?? 'null'}'); // Debug log
        print('AuthGate: user email: ${user?.email ?? 'no email'}'); // Debug log
        
        // Signed in → chat, else → your existing marketing/sign-in page
        if (user != null) {
          print('AuthGate: Navigating to JarvisChatScreen'); // Debug log
          return const JarvisChatScreen();
        } else {
          print('AuthGate: Navigating to SignInPage'); // Debug log
          return const SignInPage();
        }
      },
    );
  }
}