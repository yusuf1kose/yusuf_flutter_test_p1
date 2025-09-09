// lib/widgets/save_chat_dialog.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<String?> showSaveChatDialog(BuildContext context) {
  final controller = TextEditingController();
  final cs = Theme.of(context).colorScheme;

  return showDialog<String>(
    context: context,
    builder: (_) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.save_alt_outlined, size: 48, color: cs.primary),
              const SizedBox(height: 10),
              Text(
                'Save this chat?',
                style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.w800, color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Title this conversation so you can save\nand access it later.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14, color: cs.onSurface.withOpacity(0.75),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter a Title…',
                  filled: true,
                  fillColor: const Color(0xFFF2F3F7),
                  suffixIcon: const Icon(Icons.sell_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.06)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.06)),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: GoogleFonts.poppins()),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, controller.text.trim()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text('SAVE', style: GoogleFonts.poppins(fontWeight: FontWeight.w800)),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
