import 'package:equatable/equatable.dart';
import '../../../../core/models/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error, otpSent, otpVerified, passwordResetSuccess }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final List<String> selectedInterests;
  final String selectedGender;
  final String? errorMessage;
  final String? email; // For signup/verify flow

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.selectedInterests = const [],
    this.selectedGender = 'Male',
    this.errorMessage,
    this.email,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    List<String>? selectedInterests,
    String? selectedGender,
    String? errorMessage,
    String? email,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      selectedGender: selectedGender ?? this.selectedGender,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [status, user, selectedInterests, selectedGender, errorMessage, email];
}
