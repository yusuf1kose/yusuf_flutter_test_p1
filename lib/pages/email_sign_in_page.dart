import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'package:yusuf_flutter_test_p1/pages/email_sign_up_page.dart';
import 'package:yusuf_flutter_test_p1/widgets/Auth/email_auth_page.dart';
import 'package:yusuf_flutter_test_p1/state/providers.dart';

class EmailSignInPage extends ConsumerStatefulWidget {
  const EmailSignInPage({super.key});

  @override
  ConsumerState<EmailSignInPage> createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends ConsumerState<EmailSignInPage> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return EmailAuthPage(
      title: 'Welcome back!',
      primaryLabel: 'SIGN IN',
      showConfirm: false,
      showForgotPassword: true,
      errorMessage: _errorMessage,

      onForgotPassword: () async {
        final ok = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => _PasswordResetDialog(ref: ref),
        );
        if (ok == true && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent.')),
          );
        }
      },

      onSubmit: (email, password, {confirm}) async {
        // Clear any previous error
        setState(() => _errorMessage = null);
        
        try {
          await ref.read(authServiceProvider).signInWithEmail(
                email: email,
                password: password,
              );
          
          if (!context.mounted) return;
          Navigator.of(context).popUntil((route) => route.isFirst);
          
        } on fb.FirebaseAuthException catch (e) {
          setState(() {
            _errorMessage = _friendlyFirebase(e);
          });
        } catch (_) {
          setState(() {
            _errorMessage = 'Something went wrong. Please try again.';
          });
        }
      },
      footerQuestion: "Don't have an account?  ",
      footerCta: 'Get Started!',
      onFooterTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const EmailSignUpPage()),
        );
      },
    );
  }
}

String _friendlyFirebase(fb.FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'Invalid email address.';
    case 'user-not-found':
      return 'No account found with this email.';
    case 'wrong-password':
      return 'Wrong password. Please try again.';
    case 'invalid-credential':
      return 'Wrong email or password. Please try again.';
    case 'too-many-requests':
      return 'Too many failed attempts. Please try again later.';
    case 'network-request-failed':
      return 'Network error. Check your connection.';
    case 'user-disabled':
      return 'This account has been disabled.';
    default:
      return 'Login failed. Please try again.';
  }
}

/// Polished center dialog that manages its own state safely.
class _PasswordResetDialog extends StatefulWidget {
  const _PasswordResetDialog({required this.ref});
  final WidgetRef ref;

  @override
  State<_PasswordResetDialog> createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<_PasswordResetDialog> {
  final _controller = TextEditingController();
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final email = _controller.text.trim();
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!valid) {
      setState(() => _error = 'Enter a valid email');
      return;
    }
    setState(() {
      _error = null;
      _sending = true;
    });

    try {
      await widget.ref.read(authServiceProvider).sendPasswordResetEmail(email);
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(true);
    } on fb.FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = _friendlyFirebase(e);
        _sending = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Something went wrong. Try again.';
        _sending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      titlePadding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
      contentPadding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
      actionsPadding: const EdgeInsets.fromLTRB(12, 8, 12, 10),

      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: cs.primary.withOpacity(0.12),
            child: Icon(Icons.lock_reset_rounded, color: cs.primary),
          ),
          const SizedBox(width: 10),
          Text(
            'Reset password',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Enter your email and we'll send you a reset link.",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _send(),
            decoration: InputDecoration(
              hintText: 'you@example.com',
              prefixIcon: const Icon(Icons.mail_outline),
              errorText: _error,
              filled: true,
              fillColor: cs.surfaceContainerHighest.withOpacity(0.35),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: cs.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: cs.primary, width: 1.6),
              ),
            ),
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: _sending
              ? null
              : () => Navigator.of(context, rootNavigator: true).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _sending ? null : _send,
          icon: _sending
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send_rounded),
          label: Text(_sending ? 'Sending...' : 'Send'),
        ),
      ],
    );
  }
}