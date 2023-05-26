import 'package:chow_time_ifsp/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelButton extends StatefulWidget {
  const LabelButton(
      {super.key,
      required this.labelText,
      required this.onPressed,
      this.color});
  final String labelText;
  final VoidCallback onPressed;
  final dynamic color;

  @override
  State<LabelButton> createState() => _LabelButtonState();
}

class _LabelButtonState extends State<LabelButton> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Text(
                widget.labelText,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: widget.color ?? AppColors.primary,
                ),
              ),
      ),
    );
  }
}
