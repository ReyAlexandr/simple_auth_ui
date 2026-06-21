import 'package:flutter/material.dart';

class CenterCard extends StatelessWidget {
  const CenterCard({
    super.key,
    required this.child,
    this.leftPadding = 16,
    this.rightPadding = 16,
    this.topPadding = 32,
    this.bottomPadding = 32,
  });

  final Widget child;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            leftPadding,
            topPadding,
            rightPadding,
            bottomPadding,
          ),
          child: child,
        ),
      ),
    );
  }
}
