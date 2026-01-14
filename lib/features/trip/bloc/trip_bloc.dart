import 'package:flutter_bloc/flutter_bloc.dart';
import 'trip_event.dart';
import 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  TripBloc() : super(TripInitial()) {
    on<LoadTripsEvent>(_onLoadTrips);
    on<CreateTripEvent>(_onCreateTrip);
    on<StartTripEvent>(_onStartTrip);
    on<CancelTripEvent>(_onCancelTrip);
  }

  void _onLoadTrips(LoadTripsEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data
    final trips = List.generate(3, (index) {
      return Trip(
        id: 'trip_$index',
        name: 'Kudremukh trek',
        date: 'Oct 6 - Oct 10, 2024',
        checkpoints: [
          'Bangalore (Starting Point)',
          'Kunigal Lake (Around 70 km from Bangalore)',
          'Channarayapatna (Around 150 km from Bangalore)',
          'Charmadi Ghat (-280 km from Bangalore)',
        ],
        participants: ['User 1', 'User 2'],
      );
    });
    
    emit(TripsLoaded(trips: trips, tripType: event.tripType));
  }

  void _onCreateTrip(CreateTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (event.tripName.isEmpty) {
      emit(const TripError(message: 'Please enter trip name'));
      return;
    }
    
    if (event.locations.isEmpty || event.locations.any((loc) => loc.isEmpty)) {
      emit(const TripError(message: 'Please select all locations'));
      return;
    }
    
    final trip = Trip(
      id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
      name: event.tripName,
      date: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      checkpoints: event.locations,
      participants: event.friends,
    );
    
    emit(TripCreated(trip: trip));
  }

  void _onStartTrip(StartTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    emit(TripStarted(tripId: event.tripId));
  }

  void _onCancelTrip(CancelTripEvent event, Emitter<TripState> emit) async {
    emit(TripLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    emit(TripCancelled(tripId: event.tripId));
  }
}

