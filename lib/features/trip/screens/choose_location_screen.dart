import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:tpconnect/core/models/pcked_location.dart';

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

  Future<void> _searchPlace(String query) async {
    if (query.isEmpty) return;

    final url =
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5';

    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'trip-app'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = jsonDecode(response.body);
      });
    }
  }

  void _selectFromSearch(dynamic place) {
    final lat = double.parse(place['lat']);
    final lon = double.parse(place['lon']);

    setState(() {
      _selectedLatLng = LatLng(lat, lon);
      _selectedName = place['display_name'];
      _searchResults.clear();
      _searchController.text = _selectedName!;
    });

    _mapController.move(_selectedLatLng!, 14);
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
      setState(() {
        _selectedName = data['display_name'] ?? "Unknown Location";
      });
    } else {
      setState(() {
        _selectedName = "Unknown Location";
      });
    }
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
            /// 🔍 SEARCH BAR
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

                  /// SEARCH RESULTS
                  if (_searchResults.isNotEmpty)
                    Container(
                      height: 200,
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
                          return ListTile(
                            title: Text(
                              place['display_name'],
                              maxLines: 2,
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

            /// 🗺 MAP
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(12.9716, 77.5946), // Bangalore default
                  initialZoom: 7,
                  onTap: _onMapTap,
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
            ),

            /// 📍 SELECTED INFO
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
}
