import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.labelText = 'Password',
    this.validator,
    this.onSaved,
    this.obscureText = true,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
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
          return 'Enter a password';
        }
        if (value.trim().length < 8) {
          return 'Minimum 8 characters required';
        }
        return null;
      },
      onSaved: onSaved,
      textInputAction: textInputAction,
    );
  }
}
