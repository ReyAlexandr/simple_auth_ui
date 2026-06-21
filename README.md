# simple_auth_ui

Reusable Flutter authentication screens and fields with host-driven
authentication logic.

## Features

- Center-card login and registration templates.
- A branded phone/OTP layout with configurable branding and host widget slots.
- Reusable phone, OTP, username, and password fields.
- Authentication callbacks that keep Firebase, APIs, navigation, and state
  management in the host application.

## Getting started

Add the package to your Flutter project, then provide callbacks for your
authentication implementation.

## Usage

```dart
BrandAuthScreen(
  heading: 'Welcome',
  subHeading: 'Sign in to continue',
  quoteText: 'Your brand message',
  brandImage: Image.asset('assets/login.png'),
  topAction: const ThemeModeButton(),
  initialCountryCode: 'IN',
  isOtpMode: authState.isOtpSent,
  isLoading: authState.isLoading,
  onSendOtp: authController.sendOtp,
  onVerifyOtp: authController.verifyOtp,
  onChangePhoneNumber: authController.reset,
  socialAuthBuilder: (context, isLoading) {
    return HostSocialButtons(isDisabled: isLoading);
  },
  bottomWidget: const HostLegalFooter(),
);
```

Omit controlled state and host widget slots to use the package's built-in OTP
transition and generic Google sign-in presentation.

## Dependencies

This package relies on the following great packages:
- [flutter](https://pub.dev/packages/flutter)
- [intl_phone_field](https://pub.dev/packages/intl_phone_field)
