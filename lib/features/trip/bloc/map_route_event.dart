import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

abstract class MapRouteEvent extends Equatable {
  const MapRouteEvent();

  @override
  List<Object> get props => [];
}

class LoadRouteEvent extends MapRouteEvent {
  final List<LatLng> locations;

  const LoadRouteEvent({required this.locations});

  @override
  List<Object> get props => [locations];
}

class ClearRouteEvent extends MapRouteEvent {
  const ClearRouteEvent();
}
