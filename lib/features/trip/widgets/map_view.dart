// map_view.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

const String mapTilerKey = '';

class MapView extends StatefulWidget {
  final List<LatLng> locations;
  const MapView({super.key, required this.locations});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  List<LatLng> route = [];

  LatLng get _initialCenter {
    final a = widget.locations.first;
    final b = widget.locations.last;
    return LatLng(
      (a.latitude + b.latitude) / 2,
      (a.longitude + b.longitude) / 2,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    final coords = widget.locations
        .map((p) => '${p.longitude},${p.latitude}')
        .join(';');

    final url =
        'https://api.maptiler.com/directions/driving/geojson'
        '?coordinates=$coords'
        '&key=$mapTilerKey';

    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {
      debugPrint(res.body);
      return;
    }

    final data = jsonDecode(res.body);
    final geometry = data['features'][0]['geometry']['coordinates'] as List;

    route = geometry.map((c) => LatLng(c[1], c[0])).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bounds = LatLngBounds.fromPoints(route);
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          maxZoom: 15.5, // ~30% zoom increase
        ),
      );
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _initialCenter,
        initialZoom: 9,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$mapTilerKey',
          userAgentPackageName: 'com.example.app',
        ),

        if (route.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(points: route, strokeWidth: 7, color: Colors.red),
            ],
          ),

        MarkerLayer(
          markers: [
            Marker(
              point: widget.locations.first,
              width: 40,
              height: 40,
              child: const Icon(Icons.trip_origin, color: Colors.green),
            ),
            Marker(
              point: widget.locations.last,
              width: 40,
              height: 40,
              child: const Icon(Icons.location_pin, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
