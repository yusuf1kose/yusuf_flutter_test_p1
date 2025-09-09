// lib/widgets/Settings/display_settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yusuf_flutter_test_p1/state/providers.dart';

class DisplaySettingsPage extends ConsumerWidget {
  const DisplaySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          'Display',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
      ),
      body: const DisplaySettingsView(),
    );
  }
}

class DisplaySettingsView extends ConsumerWidget {
  const DisplaySettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final mode = ref.watch(themeModeProvider);
    final isLight = mode == ThemeMode.light;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Light Mode',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cs.outline.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isLight ? 'On' : 'Off',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                Switch(
                  value: isLight,
                  onChanged: (v) =>
                      ref.read(themeModeProvider.notifier).setLight(v),
                  activeColor: cs.onPrimary, // thumb when ON
                  activeTrackColor: cs.primary.withOpacity(0.45),
                  inactiveThumbColor: cs.onSurface.withOpacity(0.6),
                  inactiveTrackColor: cs.onSurface.withOpacity(0.25),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
