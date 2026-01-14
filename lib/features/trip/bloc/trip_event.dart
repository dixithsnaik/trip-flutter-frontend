import 'package:equatable/equatable.dart';

abstract class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object?> get props => [];
}

class LoadTripsEvent extends TripEvent {
  final String tripType; // 'Group Trips' or 'Solo Trips'

  const LoadTripsEvent({required this.tripType});

  @override
  List<Object?> get props => [tripType];
}

class CreateTripEvent extends TripEvent {
  final String tripName;
  final List<String> locations;
  final List<String> friends;
  final String instructions;

  const CreateTripEvent({
    required this.tripName,
    required this.locations,
    required this.friends,
    required this.instructions,
  });

  @override
  List<Object?> get props => [tripName, locations, friends, instructions];
}

class StartTripEvent extends TripEvent {
  final String tripId;

  const StartTripEvent({required this.tripId});

  @override
  List<Object?> get props => [tripId];
}

class CancelTripEvent extends TripEvent {
  final String tripId;

  const CancelTripEvent({required this.tripId});

  @override
  List<Object?> get props => [tripId];
}

