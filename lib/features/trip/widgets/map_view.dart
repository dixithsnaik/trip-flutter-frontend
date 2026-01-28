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
  late final MapRouteBloc _mapRouteBloc;

  LatLng? _currentLocation;

  bool _hasFittedRoute = false;
  bool _followMyLocation = false;

  @override
  void initState() {
    super.initState();
    _mapRouteBloc = MapRouteBloc()
      ..add(LoadRouteEvent(locations: widget.locations));
  }

  @override
  void dispose() {
    _mapRouteBloc.close();
    super.dispose();
  }

  /// Fit route camera (used for toggle)
  void _fitRoute(List<LatLng> route) {
    if (route.isEmpty) return;

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(route),
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 50),
      ),
    );
  }

  /// Center & mark current location
  Future<void> _centerOnCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final location = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentLocation = location;
      });

      _mapController.move(location, 15);
    } catch (_) {}
  }

  void _toggleLocationMode() async {
    if (_followMyLocation) {
      // Switch to route view
      setState(() => _followMyLocation = false);
      _fitRoute(_mapRouteBloc.state.route);
    } else {
      // Switch to follow location
      await _centerOnCurrentLocation();
      setState(() => _followMyLocation = true);
    }
  }

  void _zoomIn() {
    _mapController.move(
      _mapController.camera.center,
      _mapController.camera.zoom + 1,
    );
  }

  void _zoomOut() {
    _mapController.move(
      _mapController.camera.center,
      _mapController.camera.zoom - 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mapRouteBloc,
      child: BlocBuilder<MapRouteBloc, MapRouteState>(
        builder: (context, state) {
          if (state.status == MapRouteStatus.loaded &&
              state.route.isNotEmpty &&
              !_hasFittedRoute) {
            _hasFittedRoute = true;
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
                    /// MAP TILES
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.tripconnect.app',
                    ),

                    /// ROUTE LINE
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

                    /// ROUTE MARKERS
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

                    /// CURRENT LOCATION MARKER
                    if (_currentLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentLocation!,
                            width: 24,
                            height: 24,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                /// LOADING
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator()),

                /// ERROR
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

                /// ZOOM CONTROLS
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'zoom_in',
                        mini: true,
                        backgroundColor: Colors.blue,
                        onPressed: _zoomIn,
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 6),
                      FloatingActionButton(
                        heroTag: 'zoom_out',
                        mini: true,
                        backgroundColor: Colors.blue,
                        onPressed: _zoomOut,
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),

                /// TOGGLE LOCATION / ROUTE
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    heroTag: 'my_location',
                    backgroundColor: _followMyLocation
                        ? Colors.green
                        : Colors.blue,
                    onPressed: _toggleLocationMode,
                    child: Icon(
                      _followMyLocation ? Icons.navigation : Icons.my_location,
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
