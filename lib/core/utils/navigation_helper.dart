import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class NavigationHelper {
  /// Safely pops the current route if possible, otherwise navigates to Home.
  static void safePop(BuildContext context, [dynamic result]) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
    } else {
      Navigator.pushReplacementNamed(context, AppConstants.routeHome);
    }
  }
}
