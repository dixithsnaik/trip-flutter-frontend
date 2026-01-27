import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'map_route_event.dart';
import 'map_route_state.dart';

class MapRouteBloc extends Bloc<MapRouteEvent, MapRouteState> {
  // Credentials from your screenshot
  final String clientId = '8e9c94cf-384a-4e47-9b3b-b1cfb2b214ca';
  final String clientSecret = 'f437a83143094e41bc456dfe28f2a186';

  MapRouteBloc() : super(const MapRouteState()) {
    on<LoadRouteEvent>(_onLoadRoute);
  }

  // Helper to get OAuth Token
  Future<String?> _getAccessToken() async {
    try {
      final response = await http.post(
        Uri.parse('https://api.olamaps.io/auth/v1/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'client_credentials',
          'scope': 'openid',
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['access_token'];
      }
    } catch (e) {
      print("Auth Error: $e");
    }
    return null;
  }

  Future<void> _onLoadRoute(
    LoadRouteEvent event,
    Emitter<MapRouteState> emit,
  ) async {
    emit(state.copyWith(status: MapRouteStatus.loading, isLoading: true));

    try {
      final token = await _getAccessToken();
      if (token == null) throw Exception("Authentication failed");

      final origin =
          "${event.locations.first.latitude},${event.locations.first.longitude}";
      final destination =
          "${event.locations.last.latitude},${event.locations.last.longitude}";

      // Notice: No api_key in the URL anymore
      final response = await http.post(
        Uri.parse('https://api.olamaps.io/routing/v1/directions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // JWT Authentication
        },
        body: jsonEncode({"origin": origin, "destination": destination}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String? encodedPath = data['routes']?[0]?['overview_polyline'];

        if (encodedPath != null) {
          final List<List<num>> decoded = decodePolyline(encodedPath);
          final path = decoded
              .map((c) => LatLng(c[0].toDouble(), c[1].toDouble()))
              .toList();
          emit(
            state.copyWith(
              status: MapRouteStatus.loaded,
              route: path,
              isLoading: false,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: MapRouteStatus.error,
            errorMessage: "Error ${response.statusCode}: ${response.body}",
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: MapRouteStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
