import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JarvisInput extends StatefulWidget {
  const JarvisInput({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.autofillHints,
    this.obscure = false,
    this.suffixIcon,
    this.showObscureToggle = false,
    this.radius = 24,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  final bool obscure;
  final IconData? suffixIcon;
  final bool showObscureToggle;
  final double radius;

  @override
  State<JarvisInput> createState() => _JarvisInputState();
}

class _JarvisInputState extends State<JarvisInput> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      obscureText: _obscure,
      style: GoogleFonts.poppins(fontSize: 15, color: cs.onSurface),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: GoogleFonts.poppins(color: cs.onSurface.withOpacity(0.45)),
        filled: true,
        fillColor: const Color(0xFFF2F3F7),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        suffixIcon: widget.showObscureToggle
            ? IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                    color: cs.primary),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : (widget.suffixIcon == null
                ? null
                : Icon(widget.suffixIcon, color: cs.primary)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.06)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          borderSide: BorderSide(color: cs.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}
