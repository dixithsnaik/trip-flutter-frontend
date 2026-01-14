import 'package:equatable/equatable.dart';

class Trip {
  final String id;
  final String name;
  final String date;
  final List<String> checkpoints;
  final List<String> participants;

  const Trip({
    required this.id,
    required this.name,
    required this.date,
    required this.checkpoints,
    required this.participants,
  });
}

abstract class TripState extends Equatable {
  const TripState();

  @override
  List<Object?> get props => [];
}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripsLoaded extends TripState {
  final List<Trip> trips;
  final String tripType;

  const TripsLoaded({
    required this.trips,
    required this.tripType,
  });

  @override
  List<Object?> get props => [trips, tripType];
}

class TripCreated extends TripState {
  final Trip trip;

  const TripCreated({required this.trip});

  @override
  List<Object?> get props => [trip];
}

class TripStarted extends TripState {
  final String tripId;

  const TripStarted({required this.tripId});

  @override
  List<Object?> get props => [tripId];
}

class TripCancelled extends TripState {
  final String tripId;

  const TripCancelled({required this.tripId});

  @override
  List<Object?> get props => [tripId];
}

class TripError extends TripState {
  final String message;

  const TripError({required this.message});

  @override
  List<Object?> get props => [message];
}

