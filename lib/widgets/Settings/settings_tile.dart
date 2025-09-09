import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.iconColor = const Color(0xFF1FA774),
    this.background,                 
    this.borderRadius = 12,
    this.iconSize = 32,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color iconColor;


  final Color? background;

  final double borderRadius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final cs     = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Color tileBg = background ?? (isDark ? const Color(0xFF232327) : const Color(0xFFF2F3F7));
    final Color text   = isDark ? cs.onSurface : Colors.black87;
    final Color border = cs.outline.withOpacity(isDark ? .22 : .10);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        overlayColor: MaterialStatePropertyAll(cs.primary.withOpacity(.06)),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: tileBg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Icon(icon, size: iconSize, color: iconColor),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: text,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
