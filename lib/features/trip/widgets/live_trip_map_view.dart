import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tpconnect/core/models/user_model.dart';

class LiveTripMapView extends StatefulWidget {
  final List<LatLng> routeLocations; // checkpoints + destination
  final List<CrewLocation> crewMembers; // OTHERS ONLY

  const LiveTripMapView({
    super.key,
    required this.routeLocations,
    required this.crewMembers,
  });

  @override
  State<LiveTripMapView> createState() => _LiveTripMapViewState();
}

class _LiveTripMapViewState extends State<LiveTripMapView> {
  final MapController _mapController = MapController();
  final Distance _distance = const Distance();

  /// 🔴 MOCK CURRENT LOCATION (replace with GPS later)
  LatLng _myLocation = const LatLng(12.9735, 77.6020);

  bool _hasFitted = false;
  bool _followMe = true;

  /// 🧠 FIND NEXT CHECKPOINT (closest ahead)
  int _getNextCheckpointIndex() {
    if (widget.routeLocations.isEmpty) return -1;

    double minDistance = double.infinity;
    int closestIndex = 0;

    for (int i = 0; i < widget.routeLocations.length; i++) {
      final d = _distance(_myLocation, widget.routeLocations[i]);
      if (d < minDistance) {
        minDistance = d;
        closestIndex = i;
      }
    }
    return closestIndex;
  }

  /// 🟦 BUILD ROUTE (my location → remaining checkpoints)
  List<LatLng> _buildPolyline() {
    final nextIndex = _getNextCheckpointIndex();
    if (nextIndex == -1) return [];

    return [_myLocation, ...widget.routeLocations.sublist(nextIndex)];
  }

  /// 🎥 FIT CAMERA TO ROUTE ONLY
  void _fitRoute(List<LatLng> points) {
    if (points.isEmpty) return;

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(points),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 80),
      ),
    );
  }

  /// 📍 FOLLOW / FREE MODE
  void _toggleFollowMe() {
    setState(() => _followMe = !_followMe);

    if (_followMe) {
      _mapController.move(_myLocation, 17);
    } else {
      _fitRoute(_buildPolyline());
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
    final polyline = _buildPolyline();

    if (!_hasFitted && polyline.isNotEmpty) {
      _hasFitted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitRoute(polyline);
      });
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _myLocation,
            initialZoom: 15,
            onPositionChanged: (_, __) {
              if (_followMe) {
                _mapController.move(_myLocation, 17);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.tripconnect.app',
            ),

            /// 🟦 ROUTE POLYLINE (ONLY YOU)
            if (polyline.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: polyline,
                    strokeWidth: 5,
                    color: Colors.blueAccent,
                  ),
                ],
              ),

            /// 📍 MARKERS
            MarkerLayer(
              markers: [
                /// START
                if (widget.routeLocations.isNotEmpty)
                  _pin(widget.routeLocations.first, Colors.green),

                /// DESTINATION
                if (widget.routeLocations.length > 1)
                  _pin(widget.routeLocations.last, Colors.red),

                /// YOU (NOT IN CREW)
                _crewMarker(
                  CrewLocation(
                    userId: 'me',
                    name: 'You',
                    position: _myLocation,
                    isMe: true,
                  ),
                ),

                /// CREW MEMBERS (OTHERS ONLY)
                ...widget.crewMembers.where((c) => !c.isMe).map(_crewMarker),
              ],
            ),
          ],
        ),

        /// 🔍 ZOOM CONTROLS
        Positioned(
          left: 12,
          bottom: 70,
          child: Column(
            children: [
              _mapButton(Icons.add, _zoomIn),
              const SizedBox(height: 10),
              _mapButton(Icons.remove, _zoomOut),
            ],
          ),
        ),

        /// 📍 FOLLOW ME
        Positioned(
          right: 12,
          bottom: 70,
          child: _mapButton(Icons.my_location, _toggleFollowMe),
        ),
      ],
    );
  }

  /// 📌 SIMPLE PIN
  Marker _pin(LatLng point, Color color) {
    return Marker(
      point: point,
      width: 40,
      height: 40,
      child: Icon(Icons.location_pin, size: 40, color: color),
    );
  }

  /// 👤 CREW / YOU MARKER
  Marker _crewMarker(CrewLocation crew) {
    return Marker(
      point: crew.position,
      width: 48,
      height: 56,
      child: _CrewMarker(letter: crew.name[0].toUpperCase(), isMe: crew.isMe),
    );
  }

  Widget _mapButton(IconData icon, VoidCallback onTap) {
    return Material(
      elevation: 4,
      color: Colors.white,
      shape: const CircleBorder(),
      child: IconButton(icon: Icon(icon), onPressed: onTap),
    );
  }
}

/// 🔵 GOOGLE-MAPS STYLE MARKER
class _CrewMarker extends StatelessWidget {
  final String letter;
  final bool isMe;

  const _CrewMarker({required this.letter, this.isMe = false});

  @override
  Widget build(BuildContext context) {
    final color = isMe ? Colors.blue : Colors.orange;

    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            letter,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ClipPath(
          clipper: _NotchClipper(),
          child: Container(width: 14, height: 10, color: color),
        ),
      ],
    );
  }
}

/// 🔻 TRIANGLE NOTCH
class _NotchClipper extends CustomClipper<ui.Path> {
  @override
  ui.Path getClip(Size size) {
    final path = ui.Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<ui.Path> oldClipper) => false;
}
