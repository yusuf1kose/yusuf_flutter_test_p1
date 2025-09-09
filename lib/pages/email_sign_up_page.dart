import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:yusuf_flutter_test_p1/pages/email_sign_in_page.dart';
import 'package:yusuf_flutter_test_p1/widgets/Auth/email_auth_page.dart';
import 'package:yusuf_flutter_test_p1/state/providers.dart';

class EmailSignUpPage extends ConsumerWidget {
  const EmailSignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EmailAuthPage(
      title: 'Welcome to Jarvis GPT-3',
      primaryLabel: 'SIGN UP',
      showConfirm: true,
      onSubmit: (email, password, {confirm}) async {
        try {
          await ref.read(authServiceProvider).signUpWithEmail(
                email: email,
                password: password,
              );
          // FIX: Pop back to root and let AuthGate handle routing
          if (!context.mounted) return;
          Navigator.of(context).popUntil((route) => route.isFirst);
          
        } on FirebaseAuthException catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_friendlyFirebase(e))),
          );
        } catch (_) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong. Please try again.')),
          );
        }
      },
      footerQuestion: 'Already have an account?  ',
      footerCta: 'Log In',
      onFooterTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const EmailSignInPage()),
        );
      },
    );
  }
}

// Helper function for sign up errors
String _friendlyFirebase(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'Invalid email.';
    case 'email-already-in-use':
      return 'Email already in use.';
    case 'weak-password':
      return 'Password too weak.';
    case 'network-request-failed':
      return 'Network error. Try again.';
    default:
      return 'Auth error: ${e.code}';
  }
}