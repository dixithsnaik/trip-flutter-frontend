import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
    final isOnboarded = prefs.getBool(AppConstants.keyIsOnboarded) ?? false;

    await Future.delayed(const Duration(milliseconds: 700));
    Navigator.pushReplacementNamed(context, AppConstants.routeHome);
    // if (isLoggedIn) {
    //   Navigator.pushReplacementNamed(context, AppConstants.routeHome);
    // } else if (!isOnboarded) {
    //   Navigator.pushReplacementNamed(context, AppConstants.routeOnboarding);
    // } else {
    //   Navigator.pushReplacementNamed(context, AppConstants.routeLogin);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              LogoWidget(),
              SizedBox(height: 16),
              CircularProgressIndicator(color: AppColors.textWhite),
            ],
          ),
        ),
      ),
    );
  }
}
