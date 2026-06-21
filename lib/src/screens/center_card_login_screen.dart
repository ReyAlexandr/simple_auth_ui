import 'package:flutter/material.dart';
import '../templates/center_card_screen.dart';
import 'login_form.dart';

class CenterCardLoginScreen extends StatelessWidget {
  const CenterCardLoginScreen({
    super.key,
    required this.onLogin,
    this.topWidget,
    this.loginSubtitle = 'Login',
    this.appBar,
    this.showGoogleSignIn = true,
    this.onGoogleSignIn,
    this.socialAuthBuilder,
    this.showRegisterPrompt = false,
    this.onRegisterPrompt,
    this.fullWidthButton = false,
  });

  final Future<void> Function(String username, String password) onLogin;
  final Widget? topWidget;
  final String loginSubtitle;
  final PreferredSizeWidget? appBar;
  final bool showGoogleSignIn;
  final Future<void> Function()? onGoogleSignIn;
  final LoginSocialAuthBuilder? socialAuthBuilder;
  final bool showRegisterPrompt;
  final VoidCallback? onRegisterPrompt;
  final bool fullWidthButton;

  @override
  Widget build(BuildContext context) {
    return CenterCardScreen(
      appBar: appBar,
      body: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: LoginForm(
          toggleForm: onRegisterPrompt ?? () {},
          topWidget: topWidget,
          introText: loginSubtitle,
          showGoogleSignIn: showGoogleSignIn,
          onLogin: onLogin,
          onGoogleSignIn: onGoogleSignIn,
          socialAuthBuilder: socialAuthBuilder,
          showRegisterPrompt: showRegisterPrompt,
          fullWidthButton: fullWidthButton,
        ),
      ),
    );
  }
}
