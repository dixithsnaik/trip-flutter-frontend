import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
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

  // Get current location and center map on it
  Future<void> _centerOnCurrentLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          return;
        }
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      );

      final currentLocation = LatLng(position.latitude, position.longitude);

      // Animate map to current location
      _mapController.move(currentLocation, 15);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
    }
  }

  // Zoom in
  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + 1);
  }

  // Zoom out
  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom - 1);
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
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.tripconnect.app',
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

                // FLOATING ACTION BUTTONS: ZOOM (LEFT) & LOCATION (RIGHT)
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        heroTag: 'zoom_in',
                        onPressed: _zoomIn,
                        tooltip: 'Zoom in',
                        backgroundColor: Colors.blue,
                        mini: true,
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 4),
                      FloatingActionButton(
                        heroTag: 'zoom_out',
                        onPressed: _zoomOut,
                        tooltip: 'Zoom out',
                        backgroundColor: Colors.blue,
                        mini: true,
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),

                // FLOATING ACTION BUTTON: CENTER ON LOCATION (RIGHT)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    heroTag: 'center_location',
                    onPressed: _centerOnCurrentLocation,
                    tooltip: 'Center on my location',
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.my_location),
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
