import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yusuf_flutter_test_p1/widgets/menu_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 👈 Menu + Logo + Text grouped tightly
            Row(
              children: [
                const MenuButton(),
                const SizedBox(width: 18),
                Image.asset('assets/images/jarvis_appbar_logo.png', height: 38),
                const SizedBox(width: 4),
                Text(
                  'Jarvis',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF219653),
                  ),
                ),
              ],
            ),

            // 🔊 QR 🔁 Icons
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF1FA774)),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.qr_code_scanner, color: Color(0xFF1FA774)),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, color: Color(0xFF1FA774)),
                  iconSize: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
