import 'package:flutter/material.dart';
import 'package:simple_auth_ui/simple_auth_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Auth UI Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExampleAuthScreen(),
    );
  }
}

class ExampleAuthScreen extends StatefulWidget {
  const ExampleAuthScreen({super.key});

  @override
  State<ExampleAuthScreen> createState() => _ExampleAuthScreenState();
}

class _ExampleAuthScreenState extends State<ExampleAuthScreen> {

  Future<void> _onLogin(String username, String password) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('Logged in as $username')),
    );
  }

  Future<void> _onRegister(String username, String password) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('Registered as $username')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return CenterCardAuthScreen(
      onLogin: _onLogin,
      onRegister: _onRegister,
      topWidget: const Padding(
        padding: EdgeInsets.only(bottom: 24.0),
        child: Icon(Icons.lock_outline, size: 48, color: Colors.blue),
      ),
      loginSubtitle: 'Welcome back!',
      registerSubtitle: 'Create your account',
      showGoogleSignIn: true,
      onGoogleSignIn: () async {
        await Future.delayed(const Duration(seconds: 2));
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Google Sign-In clicked')),
        );
      },
    );
  }
}
