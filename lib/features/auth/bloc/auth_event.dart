import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthToggleInterest extends AuthEvent {
  final String interest;

  const AuthToggleInterest(this.interest);

  @override
  List<Object> get props => [interest];
}

class AuthSelectGender extends AuthEvent {
  final String gender;

  const AuthSelectGender(this.gender);

  @override
  List<Object> get props => [gender];
}

class AuthRegister extends AuthEvent {
  final String fullName;
  final String username;
  final String phoneNumber;
  final String dob;
  final String gender;
  final String vehicle;

  const AuthRegister({
    required this.fullName,
    required this.username,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    required this.vehicle,
  });

  @override
  List<Object> get props => [fullName, username, phoneNumber, dob, gender, vehicle];
}

class SignUpEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  const SignUpEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [username, email, password, confirmPassword];
}

class VerifyEmailEvent extends AuthEvent {
  final String email;
  const VerifyEmailEvent({required this.email});
  @override
  List<Object> get props => [email];
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;
  const VerifyOtpEvent({required this.email, required this.otp});
  @override
  List<Object> get props => [email, otp];
}

class ResendOtpEvent extends AuthEvent {
  final String email;
  const ResendOtpEvent({required this.email});
  @override
  List<Object> get props => [email];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String newPassword;
  final String confirmPassword;
  const ResetPasswordEvent({required this.email, required this.newPassword, required this.confirmPassword});
  @override
  List<Object> get props => [email, newPassword, confirmPassword];
}
