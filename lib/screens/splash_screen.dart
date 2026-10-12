import 'package:flutter/material.dart' hide Text;
import '../localization/rihal_localized_text.dart';

import '../rihal_style.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _pulseController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.easeOutCubic,
      ),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.96,
      end: 1.04,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _introController.forward();

    Future.delayed(
      const Duration(milliseconds: 3000),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration:
                const Duration(milliseconds: 650),
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    const LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              );

              return FadeTransition(
                opacity: curved,
                child: child,
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RihalStyle.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // خلفية هادئة بالكامل من هوية رِحال
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  RihalStyle.cardBackgroundLight,
                  RihalStyle.background,
                ],
              ),
            ),
          ),

          // زخرفة ناعمة جدًا في الخلفية
          Positioned(
            top: -90,
            right: -70,
            child: _softCircle(
              size: 220,
              color: RihalStyle.softGreen,
            ),
          ),

          Positioned(
            bottom: -110,
            left: -80,
            child: _softCircle(
              size: 260,
              color: RihalStyle.cardBackground,
            ),
          ),

          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            width: 168,
                            height: 168,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: RihalStyle.cardBackground,
                              border: Border.all(
                                color: RihalStyle.cardBorder,
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: RihalStyle.darkGreen
                                      .withValues(alpha: 0.08),
                                  blurRadius: 28,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Container(
                              width: 138,
                              height: 138,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: RihalStyle.cardBackgroundLight,
                              ),
                              child: Image.asset(
                                'assets/images/1.png',
                                width: 112,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(
                                  Icons.explore_rounded,
                                  color: RihalStyle.darkGreen,
                                  size: 66,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        const SizedBox(height: 7),

                        const Text(
                          'رحلتك على طريقتك',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: RihalStyle.secondaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 34),

                        const _LoadingDots(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Positioned(
            bottom: 22,
            right: 0,
            left: 0,
            child: SafeArea(
              top: false,
              child: Text(
                'RIHAL',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: RihalStyle.secondaryText,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _softCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.42),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (index) {
              final phase = (_controller.value + index * 0.22) % 1.0;
              final opacity =
                  0.30 + (1 - (phase - 0.5).abs() * 2) * 0.70;
              final scale =
                  0.78 + (1 - (phase - 0.5).abs() * 2) * 0.22;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity.clamp(0.30, 1.0),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: RihalStyle.darkGreen,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
