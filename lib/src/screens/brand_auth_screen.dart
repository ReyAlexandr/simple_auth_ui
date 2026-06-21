import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../social/google/google_sign_in_button.dart';
import '../social/social_divider.dart';
import '../widgets/otp_field.dart';
import '../widgets/phone_field.dart';

typedef SocialAuthBuilder =
    Widget Function(BuildContext context, bool isLoading);

class BrandAuthScreen extends StatefulWidget {
  const BrandAuthScreen({
    super.key,
    required this.brandImage,
    required this.heading,
    required this.subHeading,
    required this.quoteText,
    required this.onSendOtp,
    required this.onVerifyOtp,
    this.isOtpMode,
    this.isLoading,
    this.onChangePhoneNumber,
    this.onGoogleSignIn,
    this.showGoogleSignIn = true,
    this.socialAuthBuilder,
    this.onLoginWithUsername,
    this.loginWithUsernameText = 'Login with Username',
    this.initialCountryCode = 'US',
    this.topAction,
    this.appBar,
    this.bottomWidget,
  });

  final Widget brandImage;
  final String heading;
  final String subHeading;
  final String quoteText;

  /// Triggered after the phone field passes validation.
  final Future<void> Function(String phone) onSendOtp;

  /// Triggered when the user submits the current OTP value.
  final Future<void> Function(String otp) onVerifyOtp;

  /// When supplied, OTP mode is controlled by the host application.
  final bool? isOtpMode;

  /// When supplied, loading state is controlled by the host application.
  final bool? isLoading;

  final VoidCallback? onChangePhoneNumber;
  final Future<void> Function()? onGoogleSignIn;
  final bool showGoogleSignIn;

  /// Replaces the package's generic social sign-in section.
  final SocialAuthBuilder? socialAuthBuilder;

  final VoidCallback? onLoginWithUsername;
  final String loginWithUsernameText;
  final String initialCountryCode;

  /// Host-owned action positioned above the branding copy.
  final Widget? topAction;

  final PreferredSizeWidget? appBar;
  final Widget? bottomWidget;

  @override
  State<BrandAuthScreen> createState() => _BrandAuthScreenState();
}

class _BrandAuthScreenState extends State<BrandAuthScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _internalOtpMode = false;
  bool _internalLoading = false;
  String _phoneNumber = '';
  String _otpCode = '';

  bool get _isOtpMode => widget.isOtpMode ?? _internalOtpMode;
  bool get _isLoading => widget.isLoading ?? _internalLoading;

  void _setInternalLoading(bool value) {
    if (widget.isLoading != null || !mounted) return;
    setState(() => _internalLoading = value);
  }

  Future<void> _handleSendOtp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    _setInternalLoading(true);
    try {
      await widget.onSendOtp(_phoneNumber);
      if (widget.isOtpMode == null && mounted) {
        setState(() => _internalOtpMode = true);
      }
    } finally {
      _setInternalLoading(false);
    }
  }

  Future<void> _handleVerifyOtp() async {
    _setInternalLoading(true);
    try {
      await widget.onVerifyOtp(_otpCode);
    } finally {
      _setInternalLoading(false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (widget.onGoogleSignIn == null) return;

    _setInternalLoading(true);
    try {
      await widget.onGoogleSignIn!();
    } finally {
      _setInternalLoading(false);
    }
  }

  void _handleChangePhoneNumber() {
    if (widget.isOtpMode == null) {
      setState(() {
        _internalOtpMode = false;
        _otpCode = '';
      });
    } else {
      _otpCode = '';
    }
    widget.onChangePhoneNumber?.call();
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox.square(
      dimension: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }

  Widget _buildPhoneInput(BuildContext context) {
    final customSocialAuth = widget.socialAuthBuilder;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PhoneField(
          initialCountryCode: widget.initialCountryCode,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
          onChanged: (PhoneNumber phone) {
            _phoneNumber = phone.completeNumber;
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSendOtp,
          child: _isLoading ? _buildLoadingIndicator() : const Text('Send OTP'),
        ),
        if (customSocialAuth != null) ...[
          const SizedBox(height: 16),
          customSocialAuth(context, _isLoading),
        ] else if (widget.showGoogleSignIn) ...[
          const SizedBox(height: 16),
          const SocialDivider(),
          const SizedBox(height: 16),
          GoogleSignInButton(
            onPressed: _isLoading ? null : _handleGoogleSignIn,
            isLoading: _isLoading,
          ),
        ],
        if (widget.onLoginWithUsername != null) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: _isLoading ? null : widget.onLoginWithUsername,
            child: Text(widget.loginWithUsernameText),
          ),
        ],
      ],
    );
  }

  Widget _buildOtpInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Enter Verification Code',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        OtpField(
          decoration: const InputDecoration(
            labelText: 'OTP',
            border: OutlineInputBorder(),
            counterText: '',
          ),
          textAlign: TextAlign.start,
          textStyle: null,
          onChanged: (value) => _otpCode = value,
          onSubmitted: (_) => _handleVerifyOtp(),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleVerifyOtp,
          child: _isLoading
              ? _buildLoadingIndicator()
              : const Text('Verify OTP'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _isLoading ? null : _handleChangePhoneNumber,
          child: const Text('Change Phone Number'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.topAction != null)
                      Align(
                        alignment: Alignment.topRight,
                        child: widget.topAction,
                      ),
                    const SizedBox(height: 16),
                    Text(
                      widget.heading,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.subHeading,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Expanded(child: widget.brandImage),
                    const SizedBox(height: 16),
                    Text(
                      widget.quoteText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                        child: _isOtpMode
                            ? KeyedSubtree(
                                key: const ValueKey('otp_form'),
                                child: _buildOtpInput(),
                              )
                            : KeyedSubtree(
                                key: const ValueKey('phone_form'),
                                child: _buildPhoneInput(context),
                              ),
                      ),
                      if (widget.bottomWidget != null) ...[
                        const SizedBox(height: 24),
                        widget.bottomWidget!,
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
