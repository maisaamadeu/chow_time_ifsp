import 'package:flutter/material.dart';

class InputData extends StatelessWidget {
  const InputData(
      {super.key,
      required this.labelText,
      required this.controller,
      this.hintText,
      required this.isError,
      required this.errorText});
  final String labelText;
  final TextEditingController controller;
  final String? hintText;
  final bool isError;
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        hintText: hintText,
        errorText: isError ? errorText : null,
      ),
    );
  }
}
