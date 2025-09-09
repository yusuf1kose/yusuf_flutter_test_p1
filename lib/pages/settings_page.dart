import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yusuf_flutter_test_p1/state/providers.dart';
import 'package:yusuf_flutter_test_p1/widgets/Settings/settings_tile.dart';
import 'package:yusuf_flutter_test_p1/widgets/Settings/display_settings_page.dart';
import 'package:yusuf_flutter_test_p1/widgets/Auth/auth_gate.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
      ),
      body: const SettingsView(),
    );
  }
}

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            SettingsTile(
              icon: Icons.upgrade_rounded,
              title: 'Upgrade',
              onTap: () {},
            ),
            const SizedBox(height: 12),

            SettingsTile(
              icon: Icons.star_border_rounded,
              title: 'Rate Us',
              onTap: () {},
            ),
            const SizedBox(height: 12),

            SettingsTile(
              icon: Icons.brightness_medium_outlined,
              title: 'Display',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DisplaySettingsPage()),
                );
              },
            ),
            const SizedBox(height: 12),

            SettingsTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              onTap: () {},
            ),
            const SizedBox(height: 12),

            SettingsTile(
              icon: Icons.language_rounded,
              title: 'Language',
              onTap: () {},
            ),
            const SizedBox(height: 12),

            SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {},
            ),
            const SizedBox(height: 12),

            SettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () {},
            ),
            const SizedBox(height: 12),

            SettingsTile(
              icon: Icons.share_outlined,
              title: 'Share App',
              onTap: () {},
            ),

            const SizedBox(height: 28),

            Center(
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  backgroundColor: const Color(0xFFE84F73),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: Text(
                  'Log out',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () async {
                  print('Logout button pressed'); // Debug
                  
                  // Sign out from Firebase
                  await ref.read(authServiceProvider).signOut();
                  print('Firebase signOut completed'); // Debug
                  
                  // Navigate back to AuthGate and remove all routes
                  if (!context.mounted) return;
                  print('About to navigate to AuthGate...'); // Debug
                  
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const AuthGate()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}