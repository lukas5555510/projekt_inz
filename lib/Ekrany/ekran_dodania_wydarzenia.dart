import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text("Wybierz wydarzenie/incydent", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
    ));
  }
}
