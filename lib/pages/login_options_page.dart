import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yusuf_flutter_test_p1/pages/email_sign_in_page.dart';
import 'package:yusuf_flutter_test_p1/pages/sign_up_options_page.dart';
import 'package:yusuf_flutter_test_p1/widgets/Auth/auth_options_page.dart';
import 'package:yusuf_flutter_test_p1/state/providers.dart';

class LoginOptionsPage extends ConsumerStatefulWidget {
  const LoginOptionsPage({super.key});

  @override
  ConsumerState<LoginOptionsPage> createState() => _LoginOptionsPageState();
}

class _LoginOptionsPageState extends ConsumerState<LoginOptionsPage> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();
      
      // Navigation will be handled automatically by AuthGate
      // since the auth state will change
      
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_friendlyFirebaseError(e))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'invalid-credential':
        return 'The credential is invalid or expired.';
      case 'operation-not-allowed':
        return 'Google sign-in is not enabled.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found.';
      case 'wrong-password':
        return 'Wrong password.';
      case 'invalid-verification-code':
        return 'Invalid verification code.';
      case 'invalid-verification-id':
        return 'Invalid verification ID.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AuthOptionsPage(
          title: 'Welcome back!',
          emailLabel: 'SIGN IN WITH EMAIL',
          appleLabel: 'SIGN IN WITH APPLE',
          googleLabel: 'SIGN IN WITH GOOGLE',
          onEmail: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const EmailSignInPage()),
            );
          },
          onApple: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Apple Sign-In not implemented yet')),
            );
          },
          onGoogle: _handleGoogleSignIn,
          footerQuestion: "Don't have an account?  ",
          footerCta: 'Get Started!',
          onFooterTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SignUpOptionsPage()),
            );
          },
        ),
        
        // Loading overlay
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}