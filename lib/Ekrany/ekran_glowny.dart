import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  List<Marker> markers = [];
  String? markerTitle;
  String? markerSnippet;
  bool isAddingMarker = false; // Dodaj zmienną do sterowania trybem dodawania znacznika

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(51.2362765276371, 22.58917608263832),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

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
    _kGooglePlex = CameraPosition(target: _latLng!, zoom: 14.4746);

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
      isAddingMarker = false; // Wyłącz tryb dodawania znacznika
    });
  }


  void _onMapTapped(LatLng tappedLocation) {
    if (isAddingMarker) {
      showDialog(
        context: context,
        builder: (context) {
          String newMarkerTitle = markerTitle ?? '';
          String newMarkerSnippet = markerSnippet ?? '';

          return AlertDialog(
            title: Text('Wprowadź dane znacznika'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Tytuł znacznika'),
                  onChanged: (text) {
                    newMarkerTitle = text;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Opis znacznika'),
                  onChanged: (text) {
                    newMarkerSnippet = text;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Anuluj'),
                onPressed: () {
                  setState(() {
                    isAddingMarker = false; // Wyłącz tryb dodawania znacznika
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Dodaj znacznik'),
                onPressed: () {
                  if (newMarkerTitle.isNotEmpty & newMarkerSnippet.isNotEmpty) {
                    // Dodaj znacznik tylko gdy są dwa pola wypełnione
                    _addMarker(tappedLocation, newMarkerTitle, newMarkerSnippet);
                    setState(() {
                      isAddingMarker = false; // Wyłącz tryb dodawania znacznika
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: isAddingMarker
            ? null
            : ElevatedButton(
          onPressed: () {
            setState(() {
              isAddingMarker = true; // Włącz tryb dodawania znacznika
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.all(5),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle,
                size: 23,
              ),
              Text(
                'Dodaj wydarzenie/incydent',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
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
          onTap: _onMapTapped,
          markers: Set<Marker>.from(markers),
        ),
      ),
    );
  }
}