import 'package:flutter/material.dart';
import 'package:tpconnect/core/constants/app_constants.dart';
import 'package:tpconnect/features/profile/screens/profile_screen.dart';
import '../features/home/screens/main_screen.dart';
import '../features/chat/screens/chats_screen.dart';
import '../features/chat/screens/chat_detail_screen.dart';
import '../features/trip/screens/plan_trip_screen.dart';
import '../features/trip/screens/trip_detail_screen.dart';
import '../features/trip/screens/choose_location_screen.dart';
import '../features/auth/screens/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ...
      case AppConstants.routeHome:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case AppConstants.routeProfile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppConstants.routeChats:
        return MaterialPageRoute(builder: (_) => const ChatsScreen());
      case AppConstants.routeChatDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ChatDetailScreen(
            tripId: 'mock_trip_id', // Need to pass tripId
            tripName: args?['tripName'] ?? 'Trip Name',
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
