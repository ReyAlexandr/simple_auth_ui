import 'package:flutter/material.dart';

class ToggleTextButton extends StatelessWidget {
  const ToggleTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isDisabled = false,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      child: Text(text),
    );
  }
}
