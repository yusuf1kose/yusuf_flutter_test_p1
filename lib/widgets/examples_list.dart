import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExamplesList extends StatelessWidget {
  const ExamplesList({super.key});

  static const List<String> examples = [
    'Explain quantum computing in simple terms.',
    'Write a letter to my boss asking for a raise.',
    'Write me a shopping list for eating healthy.',
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

   
    final tileBg = isDark ? const Color(0xFF232327) : const Color(0xFFF4F3F9);

    return Column(
      children: [
        Icon(Icons.wb_sunny_outlined, size: 20, color: cs.onSurface.withOpacity(.8)),
        const SizedBox(height: 4),
        Text(
          'Examples',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: cs.onSurface.withOpacity(.85),
          ),
        ),
        ...examples.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            child: SizedBox(
              width: 325,
              height: 70,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: tileBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e,
                        style: GoogleFonts.poppins(color: cs.onSurface),
                      ),
                    ),
                    const SizedBox(width: 40),
                    const Icon(Icons.send, color: Color(0xFF219653)), 
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
