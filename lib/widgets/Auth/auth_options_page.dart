import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yusuf_flutter_test_p1/widgets/Auth/auth_button.dart';


class AuthOptionsPage extends StatelessWidget {
  const AuthOptionsPage({
    super.key,
    required this.title,
    required this.emailLabel,
    required this.appleLabel,
    required this.googleLabel,
    required this.onEmail,
    required this.onApple,
    required this.onGoogle,

    required this.footerQuestion,
    required this.footerCta,
    required this.onFooterTap,
    this.logoOpacity = 0.5,
    this.logoAlignment = const Alignment(0, -0.35),
  });

  final String title;
  final String emailLabel;
  final String appleLabel;
  final String googleLabel;
  final VoidCallback onEmail;
  final VoidCallback onApple;
  final VoidCallback onGoogle;


  final String footerQuestion;     // e.g. "Don't have an account?  "
  final String footerCta;          // e.g. "Get Started!"
  final VoidCallback onFooterTap;

  final double logoOpacity;
  final Alignment logoAlignment;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.background,
      body: Stack(
        children: [
         
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: logoAlignment,
                child: Opacity(
                  opacity: logoOpacity,
                  child: Image.asset(
                    'assets/images/jarvis_logo.png',
                    width: 280, height: 280, fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

        
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
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                
                  Container(
                    width: 80, height: 6, margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: cs.onSurface.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

               
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 26, fontWeight: FontWeight.w800, color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 18),

                
                  AuthButton(
                    label: emailLabel,
                    icon: Icons.mail_outline,
                    background: cs.primary,
                    foreground: cs.onPrimary,
                    onPressed: onEmail,
                  ),
                  const SizedBox(height: 12),

                  AuthButton(
                    label: appleLabel,
                    icon: Icons.apple,
                    background: isDark ? Colors.white : const Color(0xFF2F2F2F),
                    foreground: isDark ? Colors.black : Colors.white,
                    onPressed: onApple,
                  ),
                  const SizedBox(height: 12),

                  AuthButton(
                    label: googleLabel,
                    icon: Icons.g_mobiledata, 
                    background: const Color(0xFFC54533),
                    foreground: Colors.white,
                    onPressed: onGoogle,
                  ),

                  const SizedBox(height: 16),

             
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        footerQuestion,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: cs.onSurface.withOpacity(0.7),
                        ),
                      ),
                      GestureDetector(
                        onTap: onFooterTap,
                        child: Text(
                          footerCta,
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
        ],
      ),
    );
  }
}
