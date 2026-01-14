import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  void _onLoadProfile(LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data
    const profile = UserProfile(
      fullName: 'Dixith S Naik',
      username: 'dixithsnaik',
      email: 'dixithsnaik@gmail.com',
      phone: '+91 1234567890',
      dateOfBirth: '01/01/1990',
      gender: 'Male',
      vehicleName: 'Honda CBR',
      travelInterests: ['Solo Rider', 'Touring Enthusiast'],
    );
    
    emit(ProfileLoaded(profile: profile));
  }

  void _onUpdateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (event.fullName.isEmpty || event.username.isEmpty) {
      emit(const ProfileError(message: 'Please fill required fields'));
      return;
    }
    
    final profile = UserProfile(
      fullName: event.fullName,
      username: event.username,
      email: 'dixithsnaik@gmail.com', // From auth
      phone: event.phone,
      dateOfBirth: event.dateOfBirth,
      gender: event.gender,
      vehicleName: event.vehicleName,
      travelInterests: event.travelInterests,
    );
    
    emit(ProfileUpdated(profile: profile));
  }
}

