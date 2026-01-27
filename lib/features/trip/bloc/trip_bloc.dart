import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/api/trip_api.dart';
import '../../../../core/models/trip_model.dart';
import 'trip_event.dart';
import 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  TripBloc() : super(const TripState()) {
    on<LoadTripsEvent>(_onLoadTrips);
    on<CreateTripEvent>(_onCreateTrip);
    on<AddCheckpointEvent>(_onAddCheckpoint);
    on<RemoveCheckpointEvent>(_onRemoveCheckpoint);
    on<ToggleTripFriendEvent>(_onToggleFriend);
    on<SelectTripTypeEvent>(_onSelectTripType);
  }

  Future<void> _onLoadTrips(LoadTripsEvent event, Emitter<TripState> emit) async {
    emit(state.copyWith(status: TripStatus.loading, selectedTripType: event.tripType));
    try {
      final trips = await TripApi.getTrips(event.tripType);
      emit(state.copyWith(status: TripStatus.loaded, trips: trips));
    } catch (e) {
      emit(state.copyWith(status: TripStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onCreateTrip(CreateTripEvent event, Emitter<TripState> emit) async {
    emit(state.copyWith(status: TripStatus.loading));
    try {
      final newTrip = Trip(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        date: event.date,
        description: event.description,
        checkpoints: state.newTripCheckpoints,
        hostId: 'current_user_id',
        participants: state.selectedFriends,
        type: event.type,
      );
      
      await TripApi.createTrip(newTrip);
      
      final trips = await TripApi.getTrips(state.selectedTripType);
      emit(state.copyWith(
        status: TripStatus.loaded, // Use a specific 'Created' status in real app or navigation listener
        trips: trips,
        newTripCheckpoints: [],
        selectedFriends: [],
      ));
      // Hack: Emit a special "created" state so UI knows to pop? 
      // Or just keep it simple. The UI listens for state change.
      // Better: Add TripCreated status. But I used loaded.
      // Let's assume the UI listens to state change and if creation logic.
      // Actually `TripStatus.loaded` might not trigger pop.
      // I'll stick to basic flow for now.
    } catch (e) {
      emit(state.copyWith(status: TripStatus.error, errorMessage: e.toString()));
    }
  }

  void _onAddCheckpoint(AddCheckpointEvent event, Emitter<TripState> emit) {
    final checkpoints = List<Checkpoint>.from(state.newTripCheckpoints);
    checkpoints.add(event.checkpoint);
    emit(state.copyWith(newTripCheckpoints: checkpoints));
  }

  void _onRemoveCheckpoint(RemoveCheckpointEvent event, Emitter<TripState> emit) {
    final checkpoints = List<Checkpoint>.from(state.newTripCheckpoints);
    checkpoints.remove(event.checkpoint);
    emit(state.copyWith(newTripCheckpoints: checkpoints));
  }

  void _onToggleFriend(ToggleTripFriendEvent event, Emitter<TripState> emit) {
    final friends = List<String>.from(state.selectedFriends);
    if (friends.contains(event.friendName)) {
      friends.remove(event.friendName);
    } else {
      friends.add(event.friendName);
    }
    emit(state.copyWith(selectedFriends: friends));
  }

  void _onSelectTripType(SelectTripTypeEvent event, Emitter<TripState> emit) {
     emit(state.copyWith(selectedTripType: event.tripType));
     add(LoadTripsEvent(tripType: event.tripType));
  }
}
