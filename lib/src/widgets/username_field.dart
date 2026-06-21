import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({
    super.key,
    required this.controller,
    this.labelText = 'Username',
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.inputFormatters,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final String labelText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
      ),
      autocorrect: false,
      enableSuggestions: false,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }
}
