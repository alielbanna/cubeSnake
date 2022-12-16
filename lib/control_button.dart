import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;

  const ControlButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        width: 60.0,
        height: 60.0,
        child: FittedBox(
          child: IconButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: onPressed,
            icon: icon,
          ),
        ),
      ),
    );
  }
}
