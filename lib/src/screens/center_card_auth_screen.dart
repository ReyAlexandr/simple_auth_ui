import 'package:flutter/material.dart';
import '../templates/center_card_screen.dart';
import 'login_form.dart';
import 'register_form.dart';

class CenterCardAuthScreen extends StatefulWidget {
  const CenterCardAuthScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
    this.topWidget,
    this.registerSubtitle = 'Register',
    this.loginSubtitle = 'Login',
    this.appBar,
    this.apiKey,
    this.showGoogleSignIn = true,
    this.onGoogleSignIn,
    this.onCheckUsername,
    this.loginSocialAuthBuilder,
  });

  final Future<void> Function(String username, String password) onLogin;
  final Future<void> Function(String username, String password) onRegister;

  final Widget? topWidget;
  final String registerSubtitle;
  final String loginSubtitle;
  final PreferredSizeWidget? appBar;
  final String? apiKey;

  final bool showGoogleSignIn;
  final Future<void> Function()? onGoogleSignIn;
  final Future<bool> Function(String username)? onCheckUsername;
  final LoginSocialAuthBuilder? loginSocialAuthBuilder;

  @override
  State<CenterCardAuthScreen> createState() => _CenterCardAuthScreenState();
}

class _CenterCardAuthScreenState extends State<CenterCardAuthScreen> {
  bool _showRegister = true;

  void toggleForm() {
    setState(() {
      _showRegister = !_showRegister;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CenterCardScreen(
      appBar: widget.appBar,
      body: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: _showRegister
            ? RegisterForm(
                toggleForm: toggleForm,
                topWidget: widget.topWidget,
                introText: widget.registerSubtitle,
                showGoogleSignIn: widget.showGoogleSignIn,
                onRegister: widget.onRegister,
                onGoogleSignIn: widget.onGoogleSignIn,
                onCheckUsername: widget.onCheckUsername,
              )
            : LoginForm(
                toggleForm: toggleForm,
                topWidget: widget.topWidget,
                introText: widget.loginSubtitle,
                showGoogleSignIn: widget.showGoogleSignIn,
                onLogin: widget.onLogin,
                onGoogleSignIn: widget.onGoogleSignIn,
                socialAuthBuilder: widget.loginSocialAuthBuilder,
              ),
      ),
    );
  }
}
