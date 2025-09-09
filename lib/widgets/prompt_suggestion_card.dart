import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PromptSuggestionCard extends StatelessWidget {
  const PromptSuggestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tileBg = isDark ? const Color(0xFF232327) : const Color(0xFFF4F3F9);

    return Column(
      children: [
        Icon(Icons.help_outline_rounded, size: 22, color: cs.onSurface.withOpacity(.85)),
        const SizedBox(height: 2),
        Text(
          'Not sure of what to ask?',
          style: GoogleFonts.poppins(color: cs.onSurface),
        ),
        const SizedBox(height: 12),
        Container(
          height: 70,
          width: 325,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: tileBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: cs.onSurface,
                    ),
                    children: [
                      const TextSpan(text: 'Check out our preset prompts\nfor inspiration! '),
                      TextSpan(
                        text: 'Let’s go →',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: cs.onSurface),
                      ),
                    ],
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: Theme.of(context).cardColor,
                child: Icon(Icons.chat_bubble_outline, color: cs.onSurface),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
