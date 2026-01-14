import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

class UpdateProfileEvent extends ProfileEvent {
  final String fullName;
  final String username;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String? vehicleName;
  final List<String> travelInterests;

  const UpdateProfileEvent({
    required this.fullName,
    required this.username,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    this.vehicleName,
    required this.travelInterests,
  });

  @override
  List<Object?> get props => [fullName, username, phone, dateOfBirth, gender, vehicleName, travelInterests];
}

