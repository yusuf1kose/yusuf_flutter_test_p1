import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yusuf_flutter_test_p1/pages/jarvis_chat_screen.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F9),
      body: Stack(
        children: [
          // Green background
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(height: 250, color: const Color(0xFF00C896)),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const JarvisChatScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF4F4F4F), // text color
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.5, // make the border thicker
                      ),
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

              // Image
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, 10),
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
                        color: const Color(0xFF333333),
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                      children: [
                        const TextSpan(text: 'Meet '),
                        TextSpan(
                          text: 'Jarvis.',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF219653),
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
                            color: const Color(0xFF4F4F4F),
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            const TextSpan(text: 'The AI-powered GPT-3 '),
                            TextSpan(
                              text: 'search',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF219653),
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'content',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF219653),
                              ),
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
                            color: const Color(0xFF4F4F4F),
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: 'creation',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF219653),
                              ),
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
                          color: const Color(0xFF4F4F4F),
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D9C6F),
                      elevation: 6,
                      shadowColor: Colors.black12,
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
                            Opacity(
                              opacity: 0,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            Text(
                              'NEXT',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () {},
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        children: [
                          const TextSpan(text: 'Already have an account?   '),
                          TextSpan(
                            text: 'Log In',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF219653),
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
