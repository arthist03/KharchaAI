import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    
    // Check if Firebase is configured
    if (Firebase.apps.isEmpty) {
      context.go('/login');
      return;
    }
    
    // Check if user is already logged in
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      context.go('/');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryTeal.withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 80,
                color: AppTheme.primaryTeal,
              ),
            ).animate()
             .scale(duration: 800.ms, curve: Curves.easeOutBack)
             .fadeIn(duration: 800.ms),
            
            const SizedBox(height: 32),
            
            Text(
              'KharchaAI',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ).animate()
             .slideY(begin: 0.5, end: 0, duration: 800.ms, delay: 400.ms, curve: Curves.easeOut)
             .fadeIn(duration: 800.ms, delay: 400.ms),
             
            const SizedBox(height: 16),
            
            Text(
              'Your Personal AI Finance Manager',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ).animate()
             .fadeIn(duration: 800.ms, delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
