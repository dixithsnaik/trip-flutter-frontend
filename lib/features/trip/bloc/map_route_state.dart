import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

enum MapRouteStatus { initial, loading, loaded, error }

class MapRouteState extends Equatable {
  final MapRouteStatus status;
  final List<LatLng> route;
  final String? errorMessage;
  final bool isLoading;

  const MapRouteState({
    this.status = MapRouteStatus.initial,
    this.route = const [],
    this.errorMessage,
    this.isLoading = false,
  });

  MapRouteState copyWith({
    MapRouteStatus? status,
    List<LatLng>? route,
    String? errorMessage,
    bool? isLoading,
  }) {
    return MapRouteState(
      status: status ?? this.status,
      route: route ?? this.route,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [status, route, errorMessage, isLoading];
}
