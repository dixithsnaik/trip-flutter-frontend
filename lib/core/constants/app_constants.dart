class AppConstants {
  // App Info
  static const String appName = 'TRIP CONNECT';
  static const String appTagline = 'YOUR RIDE, YOUR TRIBE!';

  // Routes
  static const String routeSplash = '/';
  static const String routeLogin = '/login';
  static const String routeSignUp = '/signup';
  static const String routeVerifyEmail = '/verify-email';
  static const String routeOtp = '/otp';
  static const String routeResetPassword = '/reset-password';
  static const String routeOnboarding = '/onboarding';
  static const String routeHome = '/home';

  // Auth storage
  static const String keyAuthToken = 'auth_token';
  static const String routeProfile = '/profile';
  static const String routeChats = '/chats';
  static const String routeChatDetail = '/chat-detail';
  static const String routePlanTrip = '/plan-trip';
  static const String routeTripDetail = '/trip-detail';
  static const String routeChooseLocation = '/choose-location';

  // Storage Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyIsOnboarded = 'is_onboarded';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';

  // Validation
  static const int minPasswordLength = 6;
  static const int otpLength = 6;
  static const int otpExpiryMinutes = 10;

  // Placeholders
  static const String placeholderEmail = 'Email Address';
  static const String placeholderPassword = 'Password';
  static const String placeholderConfirmPassword = 'Confirm Password';
  static const String placeholderFullName = 'Full Name';
  static const String placeholderUsername = 'Username';
  static const String placeholderPhoneNo = 'Phone No';
  static const String placeholderDateOfBirth = 'DD/MM/YYYY';
  static const String placeholderVehicleName =
      'Vehicle Name & Model (optional)';
  static const String placeholderTripName = 'Name Your Trip';
  static const String placeholderMessage = 'Type your message';
  static const String placeholderInstructions =
      'Write instruction for trip....';

  // Messages
  static const String messageOtpSent =
      'Check your email {email} for the OTP. It expires in {minutes} minutes.';
  static const String messageOtpResend = "Didn't receive an email? Resend OTP";
  static const String messageResetPassword =
      'Set a new password for your account. Make sure it\'s strong and secure to protect your information.';
  static const String messageVerifyEmail =
      'You need to verify your email before resetting your password. Enter your registered email, and we\'ll send you a One-Time Password (OTP) to confirm your identity.';
  static const String messageTripInstructions =
      'this message will be circulated to all the tripmates';
}
