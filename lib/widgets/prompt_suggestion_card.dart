import 'package:flutter/material.dart';

class PromptSuggestionCard extends StatelessWidget {
  const PromptSuggestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.help_outline_rounded, size: 22),
        const SizedBox(height: 2),
        const Text(
          'Not sure of what to ask?',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 12),
        Container(
          height: 70,
          width: 325,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F3F9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(text: 'Check out our preset prompts\nfor inspiration! '),
                      TextSpan(
                        text: 'Let’s go →',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.chat_bubble_outline, color: Colors.black),
              )
            ],
          ),
        ),
      ],
    );
  }
}
