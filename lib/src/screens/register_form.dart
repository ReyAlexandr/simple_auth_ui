import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/username_field.dart';
import '../widgets/password_field.dart';
import '../widgets/confirm_password_field.dart';
import '../widgets/submit_button.dart';
import '../widgets/toggle_text.dart';
import '../social/social_divider.dart';
import '../social/google/google_sign_in_button.dart';

enum UsernameStatus { idle, checking, available, unavailable }

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.onRegister,
    required this.toggleForm,
    this.topWidget,
    this.introText = 'Register',
    this.showGoogleSignIn = true,
    this.onGoogleSignIn,
    this.onCheckUsername,
  });

  final Future<void> Function(String username, String password) onRegister;
  final VoidCallback toggleForm;
  final Widget? topWidget;
  final String introText;
  final bool showGoogleSignIn;
  final Future<void> Function()? onGoogleSignIn;
  final Future<bool> Function(String username)? onCheckUsername;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  Timer? _usernameDebounce;
  int _usernameCheckId = 0;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  UsernameStatus _usernameStatus = UsernameStatus.idle;

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onUsernameChanged(String value) {
    if (widget.onCheckUsername == null) return;
    
    _usernameDebounce?.cancel();
    final username = value.trim().toLowerCase();
    final checkId = ++_usernameCheckId;

    if (username.length < 4) {
      setState(() => _usernameStatus = UsernameStatus.idle);
      return;
    }

    setState(() => _usernameStatus = UsernameStatus.checking);
    _usernameDebounce = Timer(const Duration(milliseconds: 450), () {
      _checkUsername(username, checkId);
    });
  }

  Future<void> _checkUsername(String username, int checkId) async {
    try {
      final available = await widget.onCheckUsername!(username);
      if (!mounted || checkId != _usernameCheckId) return;
      setState(
        () => _usernameStatus = available
            ? UsernameStatus.available
            : UsernameStatus.unavailable,
      );
    } catch (_) {
      if (!mounted || checkId != _usernameCheckId) return;
      setState(() => _usernameStatus = UsernameStatus.idle);
    }
  }

  Widget? _usernameSuffixIcon() {
    if (widget.onCheckUsername == null) return null;
    return switch (_usernameStatus) {
      UsernameStatus.idle => null,
      UsernameStatus.checking => const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 16, height: 16, 
          child: CircularProgressIndicator(strokeWidth: 2)
        ),
      ),
      UsernameStatus.available => const Icon(
        Icons.check_circle,
        color: Colors.green,
      ),
      UsernameStatus.unavailable => const Icon(
        Icons.error_outline,
        color: Colors.redAccent,
      ),
    };
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_usernameStatus == UsernameStatus.unavailable) return;
    
    _formKey.currentState!.save();

    setState(() => _isLoading = true);
    try {
      await widget.onRegister(
        _usernameController.text.trim().toLowerCase(),
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
        children: [
          if (widget.topWidget != null) widget.topWidget!,
          if (widget.topWidget != null) const SizedBox(height: 16),
          Text(
            widget.introText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 32),
          UsernameField(
            controller: _usernameController,
            suffixIcon: _usernameSuffixIcon(),
            onChanged: _onUsernameChanged,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
              TextInputFormatter.withFunction((oldValue, newValue) {
                return newValue.copyWith(text: newValue.text.toLowerCase());
              }),
            ],
            validator: (value) {
              final username = (value ?? '').trim();
              if (username.isEmpty) return 'Invalid username';
              if (username.length < 4) return 'Minimum 4 characters required';
              if (_usernameStatus == UsernameStatus.unavailable) {
                return 'Username is already taken';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          PasswordField(
            controller: _passwordController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          ConfirmPasswordField(
            controller: _confirmPasswordController,
            originalPasswordController: _passwordController,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: SubmitButton(
              onPressed: disabled ? null : _submit,
              text: 'Register',
              isLoading: _isLoading,
            ),
          ),
          if (widget.showGoogleSignIn) ...[
            const SizedBox(height: 16),
            const SocialDivider(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: GoogleSignInButton(
                onPressed: disabled ? null : _submitGoogle,
                isLoading: _isGoogleLoading,
              ),
            ),
          ],
          const SizedBox(height: 16),
          ToggleTextButton(
            onPressed: disabled ? null : widget.toggleForm,
            text: 'I already have an account',
            isDisabled: disabled,
          ),
        ],
      ),
    );
  }
}
