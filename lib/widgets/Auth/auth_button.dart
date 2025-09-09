import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.background,
    required this.foreground,
    this.icon,
    this.leading,
    this.width = 260,
    this.height = 54,
    this.radius = 28,
    this.elevation = 3,
  }) : assert(icon != null || leading != null,
        'Provide either icon or leading (asset widget)');

  final String label;
  final VoidCallback onPressed;
  final Color background;
  final Color foreground;

  final IconData? icon;
  final Widget? leading;

  final double width;
  final double height;
  final double radius;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: leading ??
              Icon(icon, size: 20, color: foreground),
          label: Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: foreground,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            elevation: elevation,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),
      ),
    );
  }
}
