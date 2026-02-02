import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/models/trip_model.dart';

abstract class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object> get props => [];
}

class LoadTripsEvent extends TripEvent {
  final String tripType;

  const LoadTripsEvent({this.tripType = 'Group Trips'});

  @override
  List<Object> get props => [tripType];
}

class LoadTripDetailsEvent extends TripEvent {
  final String tripId;

  const LoadTripDetailsEvent({required this.tripId});

  @override
  List<Object> get props => [tripId];
}

class CreateTripEvent extends TripEvent {
  final String name;
  final String date;
  final String description;
  final String type;

  const CreateTripEvent({
    required this.name,
    required this.date,
    required this.description,
    required this.type,
  });

  @override
  List<Object> get props => [name, date, description, type];
}

class AddCheckpointEvent extends TripEvent {
  final Checkpoint checkpoint;

  const AddCheckpointEvent(this.checkpoint);

  @override
  List<Object> get props => [checkpoint];
}

class RemoveCheckpointEvent extends TripEvent {
  final Checkpoint checkpoint;

  const RemoveCheckpointEvent(this.checkpoint);

  @override
  List<Object> get props => [checkpoint];
}

class ToggleTripFriendEvent extends TripEvent {
  final String friendName;
  const ToggleTripFriendEvent(this.friendName);
  @override
  List<Object> get props => [friendName];
}

class SelectTripTypeEvent extends TripEvent {
  final String tripType;
  const SelectTripTypeEvent(this.tripType);
  @override
  List<Object> get props => [tripType];
}

class StartTripEvent extends TripEvent {
  final String tripId;
  final BuildContext context;
  const StartTripEvent({required this.tripId, required this.context});
  @override
  List<Object> get props => [tripId, context];
}

class CancelTripEvent extends TripEvent {
  final String tripId;
  const CancelTripEvent({required this.tripId});
  @override
  List<Object> get props => [tripId];
}
