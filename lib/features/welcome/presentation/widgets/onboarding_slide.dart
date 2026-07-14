import 'package:flutter/material.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    super.key,
    required this.imagePath,
    required this.message,
  });

  final String imagePath;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 150,
          left: 35,
          right: 60,
          child: Text(
            message,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(1, 1)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
