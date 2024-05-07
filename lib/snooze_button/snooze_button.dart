import 'package:flutter/material.dart';

class SnoozeIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SnoozeIconButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.snooze),
    );
  }
}
