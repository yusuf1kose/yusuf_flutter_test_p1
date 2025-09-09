import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yusuf_flutter_test_p1/state/providers.dart';
import 'package:yusuf_flutter_test_p1/pages/saved_chats_page.dart';
import 'package:yusuf_flutter_test_p1/pages/jarvis_chat_screen.dart';
import 'package:yusuf_flutter_test_p1/pages/settings_page.dart';

enum DrawerSection { none, chat, prompts, saved, settings }

class JarvisSideDrawer extends ConsumerWidget {
  const JarvisSideDrawer({
    super.key,
    this.active = DrawerSection.none,
    this.onNewChat,
    this.onPrompts,
    this.onSettings,
  });

  final DrawerSection active;
  final VoidCallback? onNewChat;
  final VoidCallback? onPrompts;
  final VoidCallback? onSettings;

  static const brand = Color(0xFF1FA774);
  static const selectedBg = Color(0xFFE6FAF4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(
              'Menu',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 50),

            // New Chat
            _item(
              context: context,
              icon: Icons.add,
              label: 'New Chat',
              selected: active == DrawerSection.chat,
              onTap: () {
                // clear and go to fresh chat
                ref.read(currentChatProvider.notifier).clear();
                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const JarvisChatScreen()),
                  (_) => false,
                );
                onNewChat?.call();
              },
            ),
            const SizedBox(height: 12),

            // Prompts
            _item(
              context: context,
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Prompts',
              selected: active == DrawerSection.prompts,
              onTap: () {
                Navigator.pop(context);
                if (onPrompts != null) {
                  onPrompts!();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Prompts coming soon')),
                  );
                }
              },
            ),
            const SizedBox(height: 8),

            // Saved Chats
            _item(
              context: context,
              icon: Icons.save_outlined,
              label: 'Saved Chats',
              selected: active == DrawerSection.saved,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SavedChatsPage()),
                );
              },
            ),
            const SizedBox(height: 8),

            // Settings
            _item(
              context: context,
              icon: Icons.settings_outlined,
              label: 'Settings',
              selected: active == DrawerSection.settings,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _item({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Icon(icon, color: brand, size: 28),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: selected,
      selectedTileColor: selectedBg,
      tileColor: selected ? selectedBg : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}
