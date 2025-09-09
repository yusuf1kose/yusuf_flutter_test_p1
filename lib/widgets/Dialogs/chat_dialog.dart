import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<String?> showJarvisTextDialog(
  BuildContext context, {
  required String title,
  String hint = 'Enter a Title…',
  String confirmLabel = 'SAVE',
  String cancelLabel = 'Cancel',
  String? initial,
}) async {
  final cs = Theme.of(context).colorScheme;
  final ctrl = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.save_outlined, size: 48, color: Color(0xFF1FA774)),
            const SizedBox(height: 12),
            Text(title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w800, color: cs.onSurface,
                )),
            const SizedBox(height: 10),
            TextField(
              controller: ctrl,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: const Color(0xFFF2F3F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.black.withOpacity(.06)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(cancelLabel, style: GoogleFonts.poppins()),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, ctrl.text.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  ),
                  child: Text(confirmLabel, style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<bool> showJarvisConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'DELETE',
  String cancelLabel = 'Cancel',
}) async {
  final cs = Theme.of(context).colorScheme;
  final ok = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_outline, size: 48, color: Color(0xFFE84F73)),
            const SizedBox(height: 12),
            Text(title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w800, color: cs.onSurface,
                )),
            const SizedBox(height: 10),
            Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: cs.onSurface.withOpacity(.75))),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(cancelLabel, style: GoogleFonts.poppins()),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE84F73),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  ),
                  child: Text(confirmLabel, style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return ok ?? false;
}
