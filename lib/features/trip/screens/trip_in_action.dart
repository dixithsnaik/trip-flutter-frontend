import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:tpconnect/core/models/user_model.dart';

import '../widgets/live_trip_map_view.dart';

class TripInAction extends StatefulWidget {
  const TripInAction({super.key});

  @override
  State<TripInAction> createState() => _TripInActionState();
}

class _TripInActionState extends State<TripInAction> {
  final List<LatLng> routeLatLngs = [
    LatLng(12.9716, 77.5946),
    LatLng(12.9730, 77.5965),
    LatLng(12.9750, 77.6000),
  ];

  final List<CrewLocation> crewMembers = [
    CrewLocation(userId: '2', name: 'Rahul', position: LatLng(12.975, 77.600)),
    CrewLocation(userId: '3', name: 'Anita', position: LatLng(12.968, 77.590)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip In Action")),
      body: LiveTripMapView(
        routeLocations: routeLatLngs,
        crewMembers: crewMembers,
      ),
    );
  }
}
