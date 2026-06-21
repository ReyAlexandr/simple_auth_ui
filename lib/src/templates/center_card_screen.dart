import 'package:flutter/material.dart';
import 'center_card.dart';

class CenterCardScreen extends StatelessWidget {
  const CenterCardScreen({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: CenterCard(child: body),
        ),
      ),
    );
  }
}
