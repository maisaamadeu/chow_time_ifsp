import 'package:chow_time_ifsp/shared/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class LabelButton extends StatefulWidget {
  const LabelButton(
      {super.key, required this.labelText, required this.onPressed});
  final String labelText;
  final VoidCallback onPressed;

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
                style: AppTextStyles.buttonPrimary,
              ),
      ),
    );
  }
}
