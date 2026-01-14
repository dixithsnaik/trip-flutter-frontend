import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/trip/bloc/trip_bloc.dart';
import 'features/chat/bloc/chat_bloc.dart';
import 'features/profile/bloc/profile_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => TripBloc()),
        BlocProvider(create: (_) => ChatBloc()),
        BlocProvider(create: (_) => ProfileBloc()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppConstants.routeSplash,
      ),
    );
  }
}
