import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignUpEvent>(_onSignUp);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetPasswordEvent>(_onResetPassword);
    on<ResendOtpEvent>(_onResendOtp);
    on<LogoutEvent>(_onLogout);
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Validation
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(const AuthError(message: 'Please fill all fields'));
      return;
    }

    if (!event.email.contains('@')) {
      emit(const AuthError(message: 'Please enter a valid email'));
      return;
    }

    // Simulate successful login
    final token = 'token_${DateTime.now().millisecondsSinceEpoch}';

    // Persist token and login state
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyAuthToken, token);
      await prefs.setBool(AppConstants.keyIsLoggedIn, true);
      await prefs.setString(AppConstants.keyUserEmail, event.email);
    } catch (e) {
      // ignore storage errors for now
    }

    // Notify UI
    emit(AuthAuthenticated(email: event.email, name: 'User'));
  }

  void _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Validation
    if (event.email.isEmpty ||
        event.password.isEmpty ||
        event.confirmPassword.isEmpty) {
      emit(const AuthError(message: 'Please fill all fields'));
      return;
    }

    if (!event.email.contains('@')) {
      emit(const AuthError(message: 'Please enter a valid email'));
      return;
    }

    if (event.password != event.confirmPassword) {
      emit(const AuthError(message: 'Passwords do not match'));
      return;
    }

    if (event.password.length < 6) {
      emit(const AuthError(message: 'Password must be at least 6 characters'));
      return;
    }

    // Simulate OTP sent
    emit(OtpSent(email: event.email));
  }

  void _onVerifyEmail(VerifyEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (event.email.isEmpty || !event.email.contains('@')) {
      emit(const AuthError(message: 'Please enter a valid email'));
      return;
    }

    // Simulate OTP sent
    emit(OtpSent(email: event.email));
  }

  void _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (event.otp.isEmpty || event.otp.length != 6) {
      emit(const AuthError(message: 'Please enter a valid OTP'));
      return;
    }

    // Simulate OTP verified
    emit(OtpVerified(email: event.email));
  }

  void _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (event.newPassword.isEmpty || event.confirmPassword.isEmpty) {
      emit(const AuthError(message: 'Please fill all fields'));
      return;
    }

    if (event.newPassword != event.confirmPassword) {
      emit(const AuthError(message: 'Passwords do not match'));
      return;
    }

    if (event.newPassword.length < 6) {
      emit(const AuthError(message: 'Password must be at least 6 characters'));
      return;
    }

    // Simulate password reset success
    emit(PasswordResetSuccess());
  }

  void _onResendOtp(ResendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Simulate OTP resent
    emit(OtpSent(email: event.email));
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    // Clear stored auth info
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.keyAuthToken);
      await prefs.setBool(AppConstants.keyIsLoggedIn, false);
      await prefs.remove(AppConstants.keyUserEmail);
    } catch (e) {
      // ignore
    }

    emit(AuthUnauthenticated());
  }
}
