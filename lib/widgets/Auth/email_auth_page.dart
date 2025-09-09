import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yusuf_flutter_test_p1/widgets/jarvis_input.dart';

typedef EmailAuthSubmit = Future<void> Function(
  String email,
  String password, {
  String? confirm,
});

class EmailAuthPage extends StatefulWidget {
  const EmailAuthPage({
    super.key,
    required this.title,
    required this.primaryLabel,
    required this.onSubmit,
    required this.footerQuestion,
    required this.footerCta,
    required this.onFooterTap,
    this.showConfirm = false,
    this.showForgotPassword = false,
    this.onForgotPassword,
    this.logoOpacity = 0.12,
    this.logoAlignment = const Alignment(0, -0.35),
    this.errorMessage,
  });

  final String title;
  final String primaryLabel;
  final EmailAuthSubmit onSubmit;
  final String footerQuestion;
  final String footerCta;
  final VoidCallback onFooterTap;
  final bool showConfirm;
  final bool showForgotPassword;
  final VoidCallback? onForgotPassword;
  final double logoOpacity;
  final Alignment logoAlignment;
  final String? errorMessage;

  @override
  State<EmailAuthPage> createState() => _EmailAuthPageState();
}

class _EmailAuthPageState extends State<EmailAuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.background,
      body: Stack(
        children: [
          // faint logo
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: widget.logoAlignment,
                child: Opacity(
                  opacity: widget.logoOpacity,
                  child: Image.asset(
                    'assets/images/jarvis_logo.png',
                    width: 280, height: 280, fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // bottom card
          Positioned(
            left: 24,
            right: 24,
            bottom: 24 + MediaQuery.of(context).viewPadding.bottom,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.35) : Colors.black12,
                    blurRadius: 24, offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // handle bar
                        Container(
                          width: 80, height: 6, margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: cs.onSurface.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        // title
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 26, fontWeight: FontWeight.w800, color: cs.primary,
                          ),
                        ),
                        const SizedBox(height: 22),

                        // email
                        JarvisInput(
                          controller: _email,
                          hint: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          suffixIcon: Icons.mail_outline,
                          validator: _validateEmail,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                        ),
                        const SizedBox(height: 14),

                        // password
                        JarvisInput(
                          controller: _pass,
                          hint: 'Password',
                          obscure: true,
                          showObscureToggle: true,
                          suffixIcon: Icons.vpn_key_outlined,
                          validator: _validatePassword,
                          textInputAction:
                              widget.showConfirm ? TextInputAction.next : TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                        ),

                        // Inline error message display (like form validation)
                        if (widget.errorMessage != null) ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Text(
                                widget.errorMessage!,
                                style: GoogleFonts.poppins(
                                  color: Colors.red.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],

                        if (widget.showForgotPassword) ...[
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: widget.onForgotPassword,
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.poppins(
                                color: cs.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],

                        if (widget.showConfirm) ...[
                          const SizedBox(height: 14),
                          JarvisInput(
                            controller: _confirm,
                            hint: 'Re-enter Password',
                            obscure: true,
                            showObscureToggle: true,
                            suffixIcon: Icons.vpn_key_outlined,
                            validator: (v) =>
                                v != _pass.text ? 'Passwords do not match' : null,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.newPassword],
                          ),
                        ],

                        const SizedBox(height: 18),

                        // primary button
                        SizedBox(
                          height: 54, width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 6,
                              shadowColor: isDark
                                  ? Colors.black.withOpacity(0.5)
                                  : Colors.black12,
                            ),
                            child: _submitting
                                ? const SizedBox(
                                    width: 22, height: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(
                                    widget.primaryLabel,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16, fontWeight: FontWeight.w800),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.footerQuestion,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: cs.onSurface.withOpacity(0.7),
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.onFooterTap,
                              child: Text(
                                widget.footerCta,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: cs.primary,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // validation + submit
  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email';
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Use at least 6 characters';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(
        _email.text.trim(),
        _pass.text,
        confirm: widget.showConfirm ? _confirm.text : null,
      );
    } catch (error) {
      // Don't handle errors here - let the parent handle them
      rethrow;
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}