import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:tpconnect/core/models/picked_location.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../core/utils/navigation_helper.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({super.key});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  LatLng? _selectedLatLng;
  String? _selectedName;
  List<dynamic> _searchResults = [];

  double _currentZoom = 12;

  Future<void> _searchPlace(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults.clear());
      return;
    }

    final uri = Uri.https('photon.komoot.io', '/api/', {
      'q': query,
      'lat': '22.9734',
      'lon': '78.6569',
      'limit': '10',
      'bbox': '68.1,6.5,97.4,37.6',
    });

    try {
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'tpconnect-app', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _searchResults = data['features'] ?? []);
      } else {
        setState(() => _searchResults.clear());
      }
    } catch (_) {
      setState(() => _searchResults.clear());
    }
  }

  String _buildPlaceName(Map props) {
    return props['name'] ??
        props['street'] ??
        props['suburb'] ??
        "Unnamed Location";
  }

  String _buildAddress(Map props) {
    final parts = [
      props['suburb'],
      props['city'],
      props['district'],
      props['state'],
    ];
    return parts.where((e) => e != null && e.toString().isNotEmpty).join(', ');
  }

  void _selectFromSearch(dynamic feature) {
    final coords = feature['geometry']['coordinates'];
    final props = feature['properties'];

    final lat = coords[1];
    final lon = coords[0];

    final name = _buildPlaceName(props);
    final address = _buildAddress(props);

    setState(() {
      _selectedLatLng = LatLng(lat, lon);
      _selectedName = "$name, $address";
      _searchResults.clear();
      _searchController.text = name;
    });

    _mapController.move(_selectedLatLng!, 15);
  }

  Future<void> _onMapTap(TapPosition tapPosition, LatLng latlng) async {
    setState(() {
      _selectedLatLng = latlng;
      _selectedName = "Fetching location...";
    });

    final url =
        "https://nominatim.openstreetmap.org/reverse?lat=${latlng.latitude}&lon=${latlng.longitude}&format=json";

    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'trip-app'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() => _selectedName = data['display_name']);
    } else {
      setState(() => _selectedName = "Unknown Location");
    }
  }

  Future<void> _goToCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever)
      return;

    final position = await Geolocator.getCurrentPosition();
    final latLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _selectedLatLng = latLng;
      _selectedName = "My Location";
    });

    _mapController.move(latLng, 16);
  }

  void _zoomIn() {
    _currentZoom += 1;
    _mapController.move(_mapController.camera.center, _currentZoom);
  }

  void _zoomOut() {
    _currentZoom -= 1;
    _mapController.move(_mapController.camera.center, _currentZoom);
  }

  void _confirmLocation() {
    if (_selectedLatLng == null) return;

    NavigationHelper.safePop(
      context,
      PickedLocation(
        name: _selectedName ?? "Selected Location",
        lat: _selectedLatLng!.latitude,
        lng: _selectedLatLng!.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => NavigationHelper.safePop(context),
        ),
        title: const Text(
          'Pick Location',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        actions: [
          TextButton(onPressed: _confirmLocation, child: const Text("Done")),
        ],
      ),
      body: BackgroundWidget(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.spacingMedium),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Search location...",
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _searchPlace,
                  ),
                  if (_searchResults.isNotEmpty)
                    Container(
                      height: 250,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusMedium,
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final place = _searchResults[index];
                          final props = place['properties'];

                          return ListTile(
                            leading: const Icon(Icons.location_on_outlined),
                            title: Text(
                              _buildPlaceName(props),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              _buildAddress(props).isEmpty
                                  ? "Unknown area"
                                  : _buildAddress(props),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => _selectFromSearch(place),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(12.9716, 77.5946),
                      initialZoom: _currentZoom,
                      onTap: _onMapTap,
                      onPositionChanged: (pos, _) {
                        _currentZoom = pos.zoom ?? _currentZoom;
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.tripapp',
                      ),
                      if (_selectedLatLng != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _selectedLatLng!,
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  Positioned(
                    left: 12,
                    bottom: 40,
                    child: Column(
                      children: [
                        _mapButton(Icons.add, _zoomIn),
                        const SizedBox(height: 10),
                        _mapButton(Icons.remove, _zoomOut),
                      ],
                    ),
                  ),

                  Positioned(
                    right: 12,
                    bottom: 40,
                    child: _mapButton(Icons.my_location, _goToCurrentLocation),
                  ),
                ],
              ),
            ),

            if (_selectedName != null)
              Padding(
                padding: const EdgeInsets.all(AppSizes.spacingMedium),
                child: Text(
                  _selectedName!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _mapButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      child: IconButton(icon: Icon(icon), onPressed: onTap),
    );
  }
}
