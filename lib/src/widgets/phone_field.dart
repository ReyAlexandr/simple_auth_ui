import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.onChanged,
    this.initialCountryCode = 'US',
    this.decoration,
  });

  final void Function(PhoneNumber) onChanged;
  final String initialCountryCode;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: decoration ?? const InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(),
      ),
      initialCountryCode: initialCountryCode,
      onChanged: onChanged,
    );
  }
}
