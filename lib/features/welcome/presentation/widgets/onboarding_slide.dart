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
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            cacheWidth: (screenWidth * devicePixelRatio).round(),
          ),
        ),
        // Scrim so the message stays readable regardless of what's behind it.
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.5, 1],
                colors: [Colors.black.withValues(alpha: 0), Colors.black.withValues(alpha: 0.65)],
              ),
            ),
          ),
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
                Shadow(color: Colors.black87, blurRadius: 8, offset: Offset(1, 1)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
