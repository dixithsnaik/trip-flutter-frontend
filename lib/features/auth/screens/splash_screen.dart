import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
    final isOnboarded = prefs.getBool(AppConstants.keyIsOnboarded) ?? false;

    await Future.delayed(const Duration(milliseconds: 1500));

    String nextRoute;
    if (isLoggedIn) {
      nextRoute = AppConstants.routeHome;
    } else if (!isLoggedIn) {
      nextRoute = AppConstants.routeLogin;
    } else if (!isOnboarded) {
      nextRoute = AppConstants.routeOnboarding;
    } else {
      nextRoute = AppConstants.routeOnboarding;
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Lottie.asset(
            'assets/lottie/loading.json',
            width: 300,
            height: 300,
            repeat: true,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
