import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'map_route_event.dart';
import 'map_route_state.dart';

class MapRouteBloc extends Bloc<MapRouteEvent, MapRouteState> {
  MapRouteBloc() : super(const MapRouteState()) {
    on<LoadRouteEvent>(_onLoadRoute);
  }

  Future<void> _onLoadRoute(
    LoadRouteEvent event,
    Emitter<MapRouteState> emit,
  ) async {
    emit(state.copyWith(status: MapRouteStatus.loading, isLoading: true));

    try {
      if (event.locations.length < 2) {
        throw Exception("At least 2 locations required for routing");
      }

      final List<LatLng> completePath = [];

      // Route point-to-point through all locations
      for (int i = 0; i < event.locations.length - 1; i++) {
        final origin = event.locations[i];
        final destination = event.locations[i + 1];

        // Using OSRM (Open Source Routing Machine) - free OpenStreetMap routing
        final coordinates =
            "${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}";

        final response = await http.get(
          Uri.parse(
            'https://router.project-osrm.org/route/v1/driving/$coordinates?overview=full&geometries=geojson',
          ),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data['routes'] != null && data['routes'].isNotEmpty) {
            final route = data['routes'][0];
            final routeCoordinates = route['geometry']['coordinates'] as List;

            final segmentPath = routeCoordinates
                .map(
                  (coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()),
                )
                .toList();

            // Add segment to complete path, avoiding duplicate points
            if (completePath.isNotEmpty && segmentPath.isNotEmpty) {
              segmentPath.removeAt(
                0,
              ); // Remove first point to avoid duplication
            }
            completePath.addAll(segmentPath);
          } else {
            throw Exception("No routes found for segment ${i + 1}");
          }
        } else {
          throw Exception(
            "Error ${response.statusCode}: ${response.body} for segment ${i + 1}",
          );
        }
      }

      emit(
        state.copyWith(
          status: MapRouteStatus.loaded,
          route: completePath,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MapRouteStatus.error,
          errorMessage: e.toString(),
          isLoading: false,
        ),
      );
    }
  }
}
