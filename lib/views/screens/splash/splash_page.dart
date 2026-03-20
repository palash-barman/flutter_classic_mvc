import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_classic_mvc/controllers/splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = Get.put(SplashController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.7),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo or App Icon
            AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 600),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.shopping_bag,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // App Name
            Text(
              'Demo Project',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Tagline
            Text(
              'Your Shopping Companion',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 60),

            // Loading Indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withValues(alpha: 0.8),
              ),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
