import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/onboarding_slide.dart';
import '../widgets/welcome_actions.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  Timer? _autoAdvanceTimer;
  int _currentPage = 0;

  static const List<OnboardingSlide> _slides = [
    OnboardingSlide(
      imagePath: 'assets/photos/bg1.jpg',
      message: 'Accede a créditos con un solo toque y sin complicaciones.',
    ),
    OnboardingSlide(
      imagePath: 'assets/photos/bg2.jpg',
      message: 'Toma el control de tus finanzas con confianza y accede a ellas sin restricciones.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _autoAdvanceTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _currentPage = _currentPage < _slides.length - 1 ? _currentPage + 1 : 0;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: _slides,
          ),
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(child: WelcomeActions()),
          ),
        ],
      ),
    );
  }
}
