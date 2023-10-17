import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'ekran_dodawania_wydarzenia.dart';

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
  bool isAddingMarker = false;

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
      isAddingMarker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex ?? _kLake,
              myLocationButtonEnabled: true,
              padding: const EdgeInsets.only(top: 28, right: 0),
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (LatLng latLng) {
                if (isAddingMarker) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarkerDetailsScreen(
                        onMarkerSaved: (title, snippet) {
                          if (title.isNotEmpty && snippet.isNotEmpty) {
                            _addMarker(latLng, title, snippet);
                          }
                        },
                        onMarkerCancelled: () {
                          setState(() {
                            isAddingMarker = false;
                          });
                        },
                      ),
                    ),
                  );
                }
              },
              markers: Set<Marker>.from(markers),
            ),
            if (isAddingMarker)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.blue.withOpacity(0.8),
                  padding: const EdgeInsets.all(10),
                  child: const Center(
                    child: Text(
                      'Kliknij na mapę, aby wybrać miejsce wydarzenia/incydentu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

          ],
        ),
        floatingActionButton: isAddingMarker
            ? FloatingActionButton(
          onPressed: () {
            setState(() {
              isAddingMarker = false; // Wyłącz tryb dodawania znacznika
            });
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.close),
        )
            : ElevatedButton(
          onPressed: () {
            setState(() {
              isAddingMarker = true; // Włącz tryb dodawania znacznika
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.all(5),
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
      ),
    );
  }
}
