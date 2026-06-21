import 'package:flutter/material.dart';

class ConfirmPasswordField extends StatelessWidget {
  const ConfirmPasswordField({
    super.key,
    this.controller,
    required this.originalPasswordController,
    this.labelText = 'Confirm password',
    this.validator,
    this.obscureText = true,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController? controller;
  final TextEditingController originalPasswordController;
  final String labelText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      obscureText: obscureText,
      validator: validator ?? (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Confirm your password';
        }
        if (value.trim() != originalPasswordController.text.trim()) {
          return 'Passwords do not match';
        }
        return null;
      },
      textInputAction: textInputAction,
    );
  }
}
