import 'package:flutter/material.dart';

class ExamplesList extends StatelessWidget {
  const ExamplesList({super.key});

  final List<String> examples = const [
    'Explain quantum computing in simple terms.',
    'Write a letter to my boss asking for a raise.',
    'Write me a shopping list for eating healthy.',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.wb_sunny_outlined, size: 20),
        const SizedBox(height: 4),
        const Text(
          'Examples',
          style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
        ),
       
        ...examples.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            child: Container(
              width: 325, 
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F3F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      e,
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                  SizedBox(width: 40),
                  const Icon(Icons.send, color: Color(0xFF219653)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
