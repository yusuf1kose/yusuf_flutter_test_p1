// lib/widgets/jarvis_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yusuf_flutter_test_p1/widgets/menu_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSearchPressed;
  
  const CustomAppBar({super.key, this.onSearchPressed});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color barColor =
        theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;

    final overlay = (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
      statusBarColor: barColor,
      systemNavigationBarColor: barColor,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Container(
        color: barColor,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Builder(
                  builder: (ctx) => GestureDetector(
                    onTap: () => Scaffold.of(ctx).openDrawer(),
                    behavior: HitTestBehavior.opaque,
                    child: const MenuButton(),
                  ),
                ),
                const SizedBox(width: 18),
                Image.asset('assets/images/jarvis_appbar_logo.png', height: 38),
                const SizedBox(width: 4),
                Text(
                  'Jarvis',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF219653), // brand green
                  ),
                ),
              ]),
              Row(children: [
                _AppIcon(
                  icon: Icons.search,
                  onPressed: onSearchPressed,
                ),
                const _AppIcon(icon: Icons.volume_up_rounded),
                const _AppIcon(icon: Icons.qr_code_scanner),
                const _AppIcon(icon: Icons.refresh),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.icon, this.onPressed});
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () {},
      icon: Icon(icon, color: const Color(0xFF1FA774)),
      iconSize: 30,
    );
  }
}