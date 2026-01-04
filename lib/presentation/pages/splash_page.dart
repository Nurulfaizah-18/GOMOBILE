import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/theme/app_colors.dart';
import 'landing_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    // Navigate ke Landing Page setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LandingPage(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          // Animated Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkBg,
                  AppColors.darkBg.withValues(alpha: 0.9),
                  const Color(0xFF1a1a2e),
                ],
              ),
            ),
          ),

          // Animated circles
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer circle
                ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.2).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.0, 0.6),
                    ),
                  ),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.electricBlue.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                // Middle circle
                ScaleTransition(
                  scale: Tween<double>(begin: 0.6, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.2, 0.8),
                    ),
                  ),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.electricBlue.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                // Logo Circle (Inner)
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.electricBlue,
                            AppColors.electricBlue.withValues(alpha: 0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.electricBlue.withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.directions_car,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom text
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Text(
                    'Sewa Kendaraan',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Temukan Kendaraan Impian Anda',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Loading indicator
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.electricBlue),
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
