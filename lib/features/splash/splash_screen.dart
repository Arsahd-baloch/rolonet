import 'package:flutter/material.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    // Navigate to /landing after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        AppRouter.toLanding(context);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFDBEAFE), // light blue
                AppTheme.lightBlue,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(scale: _scaleAnim, child: child),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Logo icon placeholder
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E40AF).withOpacity(0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 52,
                  ),
                ),

                const SizedBox(height: 28),

                // App name
                const Text(
                  'ReliefNet',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 10),

                // Tagline
                const Text(
                  'Connecting Aid. Delivering Hope.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                  ),
                ),

                const Spacer(flex: 2),

                // Loading indicator at bottom
                const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryBlue,
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
