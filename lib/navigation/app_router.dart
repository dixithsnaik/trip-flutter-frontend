import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/verify_email_screen.dart';
import '../features/auth/screens/otp_screen.dart';
import '../features/auth/screens/reset_password_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/chat/screens/chats_screen.dart';
import '../features/chat/screens/chat_detail_screen.dart';
import '../features/trip/screens/plan_trip_screen.dart';
import '../features/trip/screens/trip_detail_screen.dart';
import '../features/trip/screens/choose_location_screen.dart';
import '../features/auth/screens/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.routeLogin:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppConstants.routeSignUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case AppConstants.routeVerifyEmail:
        return MaterialPageRoute(builder: (_) => const VerifyEmailScreen());
      case AppConstants.routeOtp:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(email: args?['email'] ?? ''),
        );
      case AppConstants.routeResetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case AppConstants.routeOnboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppConstants.routeHome:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppConstants.routeProfile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppConstants.routeChats:
        return MaterialPageRoute(builder: (_) => const ChatsScreen());
      case AppConstants.routeChatDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ChatDetailScreen(
            tripName: args?['tripName'] ?? 'Trip Name',
            date: args?['date'] ?? '21/10/25',
          ),
        );
      case AppConstants.routePlanTrip:
        return MaterialPageRoute(builder: (_) => const PlanTripScreen());
      case AppConstants.routeTripDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>
              TripDetailScreen(tripName: args?['tripName'] ?? 'TRIP NAME'),
        );
      case AppConstants.routeChooseLocation:
        return MaterialPageRoute(builder: (_) => const ChooseLocationScreen());
      case AppConstants.routeSplash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      default:
        // Unknown routes should go through splash which decides the next screen
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
