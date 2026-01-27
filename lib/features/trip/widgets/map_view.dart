import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../bloc/map_route_bloc.dart';
import '../bloc/map_route_event.dart';
import '../bloc/map_route_state.dart';

class MapView extends StatefulWidget {
  final List<LatLng> locations;
  const MapView({super.key, required this.locations});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  final String olaApiKey = 'hKKnYHbPpZxmBPSIwZfLvOAh7oxqxx1wCfPtbgx6';

  // Fits the camera so the entire route is visible
  void _fitRoute(List<LatLng> route) {
    if (route.isEmpty) return;

    // Tiny delay to ensure the widget is built
    Future.delayed(const Duration(milliseconds: 300), () {
      final bounds = LatLngBounds.fromPoints(route);
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 50),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MapRouteBloc()..add(LoadRouteEvent(locations: widget.locations)),
      child: BlocBuilder<MapRouteBloc, MapRouteState>(
        builder: (context, state) {
          // Listen for a loaded route to adjust the camera
          if (state.status == MapRouteStatus.loaded && state.route.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _fitRoute(state.route),
            );
          }

          return Scaffold(
            body: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: widget.locations.isNotEmpty
                        ? widget.locations.first
                        : const LatLng(12.9716, 77.5946),
                    initialZoom: 13,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://api.olamaps.io/tiles/v1/styles/default-light-standard/{z}/{x}/{y}.png?api_key=$olaApiKey',
                      userAgentPackageName: 'com.tpconnect.app',
                      tileUpdateTransformer: TileUpdateTransformers.throttle(
                        const Duration(milliseconds: 150),
                      ),
                      keepBuffer: 1,
                      panBuffer: 0,
                    ),

                    // THE ROUTE LINE
                    if (state.route.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: state.route,
                            strokeWidth: 5,
                            color: Colors.blueAccent,
                            borderColor: Colors.blue.shade900,
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),

                    // MARKERS FOR START AND END
                    MarkerLayer(
                      markers: widget.locations.map((pos) {
                        final isStart = pos == widget.locations.first;
                        return Marker(
                          point: pos,
                          width: 40,
                          height: 40,
                          child: Icon(
                            isStart
                                ? Icons.radio_button_checked
                                : Icons.location_on,
                            color: isStart ? Colors.green : Colors.red,
                            size: 35,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // OVERLAY: LOADING SPINNER
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator()),

                // OVERLAY: ERROR BAR
                if (state.errorMessage != null)
                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
