import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TripInAction extends StatefulWidget {
  const TripInAction({super.key});

  @override
  State<TripInAction> createState() => _TripInActionState();
}

class _TripInActionState extends State<TripInAction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip In Action")),
      body: const Center(child: Text("Trip In Action Screen")),
    );
  }
}
