import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inzynierka/Ekrany/ekran_dodania_wydarzenia.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  LatLng? _latLng;

  CameraPosition? _kGooglePlex;

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  List<Marker> markers = [];
  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    _latLng = LatLng(_locationData.latitude!, _locationData.longitude!);
    _kGooglePlex = CameraPosition(
      target: _latLng!,
      zoom: 14.4746,
    );

    // Check if _kGooglePlex is not null before updating the map position
    if (_kGooglePlex != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex!));
    }

    setState(() {});
  }

  void _addMarker(LatLng location, String title, String snippet) {
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(markers.length.toString()),
          position: location,
          infoWindow: InfoWindow(title: title, snippet: snippet),
        ),
      );
    });
  }
  String? markerTitle;
  String? markerSnippet;


  void _onMapTapped(LatLng tappedLocation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Wprowadź dane znacznika'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Tytuł znacznika'),
                onChanged: (text) {
                  setState(() {
                    markerTitle = text;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Opis znacznika'),
                onChanged: (text) {
                  setState(() {
                    markerSnippet = text;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Anuluj'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Dodaj znacznik'),
              onPressed: () {
                if (markerTitle != null && markerSnippet != null) {
                  _addMarker(tappedLocation, markerTitle!, markerSnippet!);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }



  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EventScreen()));
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex ?? _kLake,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: _onMapTapped, // Obsługa kliknięcia na mapie
          markers: Set<Marker>.from(markers),
        ),
      ),
    );
  }
}