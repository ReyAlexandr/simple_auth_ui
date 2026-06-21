import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpField extends StatelessWidget {
  const OtpField({
    super.key,
    required this.onChanged,
    this.onSubmitted,
    this.length = 6,
    this.decoration,
    this.textAlign = TextAlign.center,
    this.textStyle = const TextStyle(letterSpacing: 8.0, fontSize: 18),
  });

  final void Function(String) onChanged;
  final void Function(String)? onSubmitted;
  final int length;
  final InputDecoration? decoration;
  final TextAlign textAlign;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(length),
      ],
      decoration:
          decoration ??
          const InputDecoration(labelText: 'OTP', border: OutlineInputBorder()),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      textAlign: textAlign,
      style: textStyle,
    );
  }
}
