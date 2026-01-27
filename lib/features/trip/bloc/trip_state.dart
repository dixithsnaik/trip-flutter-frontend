import 'package:equatable/equatable.dart';
import '../../../../core/models/trip_model.dart';

enum TripStatus { initial, loading, loaded, error, started, cancelled }

class TripState extends Equatable {
  final TripStatus status;
  final List<Trip> trips;
  final String? errorMessage;
  // Local state for trip creation
  final List<Checkpoint> newTripCheckpoints;
  final List<String> selectedFriends;
  final String selectedTripType;

  const TripState({
    this.status = TripStatus.initial,
    this.trips = const [],
    this.errorMessage,
    this.newTripCheckpoints = const [],
    this.selectedFriends = const [],
    this.selectedTripType = 'Group Trips',
  });

  TripState copyWith({
    TripStatus? status,
    List<Trip>? trips,
    String? errorMessage,
    List<Checkpoint>? newTripCheckpoints,
    List<String>? selectedFriends,
    String? selectedTripType,
  }) {
    return TripState(
      status: status ?? this.status,
      trips: trips ?? this.trips,
      errorMessage: errorMessage ?? this.errorMessage,
      newTripCheckpoints: newTripCheckpoints ?? this.newTripCheckpoints,
      selectedFriends: selectedFriends ?? this.selectedFriends,
      selectedTripType: selectedTripType ?? this.selectedTripType,
    );
  }

  @override
  List<Object?> get props => [status, trips, errorMessage, newTripCheckpoints, selectedFriends, selectedTripType];
}
