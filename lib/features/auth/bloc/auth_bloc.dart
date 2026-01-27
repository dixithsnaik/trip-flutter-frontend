import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoginEvent>(_onLogin);
    on<AuthToggleInterest>(_onToggleInterest);
    on<AuthSelectGender>(_onSelectGender);
    on<AuthRegister>(_onRegister);
    on<SignUpEvent>(_onSignUp);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  void _onSelectGender(AuthSelectGender event, Emitter<AuthState> emit) {
    emit(state.copyWith(selectedGender: event.gender));
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 1)); // Simulate latency
    
    // Mock login success
    final user = User(
      id: '123', 
      fullName: 'Test User',
      username: 'testuser',
      phoneNumber: '9876543210',
      dateOfBirth: '01/01/1990',
      gender: 'Male',
      interests: [],
    );
    
    emit(state.copyWith(status: AuthStatus.authenticated, user: user));
  }

  void _onToggleInterest(AuthToggleInterest event, Emitter<AuthState> emit) {
    final interests = List<String>.from(state.selectedInterests);
    if (interests.contains(event.interest)) {
      interests.remove(event.interest);
    } else {
      interests.add(event.interest);
    }
    emit(state.copyWith(selectedInterests: interests));
  }

  Future<void> _onRegister(AuthRegister event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 1));

    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: event.fullName,
      username: event.username,
      phoneNumber: event.phoneNumber,
      dateOfBirth: event.dob,
      gender: event.gender,
      interests: state.selectedInterests,
    );

    emit(state.copyWith(status: AuthStatus.authenticated, user: user));
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    // Simulate Success -> OTP Sent or Authenticated
    // Ideally after generic signup we might verify email.
    // Let's assume generic signup leads to authenticated for this mock unless Verify is required.
    // If we follow typical flow: Signup -> (maybe Verify Email) -> Authenticated.
    // But existing UI (SignUpScreen) listens for OtpSent.
    emit(state.copyWith(status: AuthStatus.authenticated, email: event.email)); 
  }

  Future<void> _onVerifyEmail(VerifyEmailEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(status: AuthStatus.otpSent, email: event.email));
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    if (event.otp == "123456") {
       emit(state.copyWith(status: AuthStatus.otpVerified)); 
    } else {
       emit(state.copyWith(status: AuthStatus.error, errorMessage: "Invalid OTP"));
    }
  }

  Future<void> _onResendOtp(ResendOtpEvent event, Emitter<AuthState> emit) async {
     // Just re-emit otpSent to trigger snackbar if needed, or maintain current state but show feedback
     emit(state.copyWith(status: AuthStatus.otpSent));
  }

  Future<void> _onResetPassword(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
     await Future.delayed(const Duration(seconds: 1));
     emit(state.copyWith(status: AuthStatus.passwordResetSuccess));
  }
}
