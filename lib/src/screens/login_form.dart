import 'package:flutter/material.dart';
import '../widgets/username_field.dart';
import '../widgets/password_field.dart';
import '../widgets/submit_button.dart';
import '../widgets/toggle_text.dart';
import '../social/social_divider.dart';
import '../social/google/google_sign_in_button.dart';

typedef LoginSocialAuthBuilder =
    Widget Function(BuildContext context, bool isLoading);

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onLogin,
    required this.toggleForm,
    this.topWidget,
    this.introText = 'Login',
    this.showGoogleSignIn = true,
    this.onGoogleSignIn,
    this.socialAuthBuilder,
    this.showRegisterPrompt = true,
  });

  final Future<void> Function(String username, String password) onLogin;
  final VoidCallback toggleForm;
  final Widget? topWidget;
  final String introText;
  final bool showGoogleSignIn;
  final Future<void> Function()? onGoogleSignIn;
  final LoginSocialAuthBuilder? socialAuthBuilder;
  final bool showRegisterPrompt;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);
    try {
      await widget.onLogin(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitGoogle() async {
    if (widget.onGoogleSignIn == null) return;
    setState(() => _isGoogleLoading = true);
    try {
      await widget.onGoogleSignIn!();
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = _isLoading || _isGoogleLoading;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          if (widget.topWidget != null) widget.topWidget!,
          Text(
            widget.introText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          UsernameField(
            controller: _usernameController,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Provide a valid username'
                : null,
          ),
          PasswordField(controller: _passwordController),
          const SizedBox(height: 16),
          SubmitButton(
            onPressed: disabled ? null : _submit,
            text: 'Login',
            isLoading: _isLoading,
          ),
          if (widget.socialAuthBuilder != null)
            widget.socialAuthBuilder!(context, disabled)
          else if (widget.showGoogleSignIn)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                const SocialDivider(),
                GoogleSignInButton(
                  onPressed: disabled ? null : _submitGoogle,
                  isLoading: _isGoogleLoading,
                ),
              ],
            ),
          if (widget.showRegisterPrompt)
            ToggleTextButton(
              onPressed: disabled ? null : widget.toggleForm,
              text: "I don't have an account",
              isDisabled: disabled,
            ),
        ],
      ),
    );
  }
}
