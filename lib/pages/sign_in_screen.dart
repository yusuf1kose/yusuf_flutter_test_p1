import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yusuf_flutter_test_p1/pages/jarvis_chat_screen.dart';
import 'package:yusuf_flutter_test_p1/pages/login_options_page.dart';
import 'package:yusuf_flutter_test_p1/pages/sign_up_options_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Light gray background
      body: Stack(
        children: [
          // Teal background with subtle own-shade gradient
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    cs.secondary, // top teal
                    cs.secondaryContainer, // slightly darker teal
                  ],
                ),
              ),
            ),
          ),

          // Main column content
          Column(
            children: [
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: () {
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: cs.surface,
                      foregroundColor: cs.onSurface,
                      side: BorderSide(color: cs.outline, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Skip'),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Logo image
              Image.asset(
                'assets/images/jarvis_logo.png',
                width: 380,
                height: 380,
              ),
            ],
          ),

          // White card OVERLAPPING
          Positioned(
            left: 24,
            right: 24,
            bottom: 70,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.35)
                        : Colors.black12,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/progress_indicator.png',
                    width: 60,
                    height: 20,
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        color: cs.onSurface,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                      children: [
                        const TextSpan(text: 'Meet '),
                        TextSpan(
                          text: 'Jarvis.',
                          style: GoogleFonts.poppins(
                            color: cs.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: cs.onSurface,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            const TextSpan(text: 'The AI-powered GPT-3 '),
                            TextSpan(
                              text: 'search',
                              style: GoogleFonts.poppins(color: cs.primary),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'content',
                              style: GoogleFonts.poppins(color: cs.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: cs.onSurface,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: 'creation',
                              style: GoogleFonts.poppins(color: cs.primary),
                            ),
                            const TextSpan(
                              text: ' app that gives you accurate, ad-',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'free results instantly.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: cs.onSurface,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Sign Up Options Page
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignUpOptionsPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      elevation: 6,
                      shadowColor: isDark
                          ? Colors.black.withOpacity(0.5)
                          : Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: SizedBox(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Opacity(
                              opacity: 0,
                              child: Icon(Icons.arrow_forward, size: 20),
                            ),
                            Text(
                              'NEXT',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: cs.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () {
                      // Navigate to Login Options Page
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LoginOptionsPage(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: cs.onSurfaceVariant,
                        ),
                        children: [
                          const TextSpan(text: 'Already have an account?   '),
                          TextSpan(
                            text: 'Log In',
                            style: GoogleFonts.poppins(
                              color: cs.primary,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}