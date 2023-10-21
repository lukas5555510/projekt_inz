import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'ekran_dodawania_wydarzenia.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key});

  @override
  State<MapSample> createState() => MapSampleState();
}
class EventDetails {
  final String title;
  final String description;
  final DateTime eventDate;


  EventDetails({
    required this.title,
    required this.description,
    required this.eventDate,

  });
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  LatLng? _latLng;
  CameraPosition? _kGooglePlex;
  List<Marker> markers = [];
  String? markerTitle;
  String? markerSnippet;
  bool isAddingMarker = false;
  File? selectedImageFile; // Przechowuje wybrany obraz
  Map<LatLng, EventDetails> eventDetailsMap = {};


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
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    _latLng = LatLng(locationData.latitude!, locationData.longitude!);
    _kGooglePlex = CameraPosition(target: _latLng!, zoom: 14.4746);

    if (_kGooglePlex != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex!));
    }

    setState(() {});
  }

  Future<void> _addImageMarker(LatLng location, String title, String snippet, DateTime eventDate) async {
    if (selectedImageFile != null) {
      final BitmapDescriptor imageMarker = BitmapDescriptor.fromBytes(
        (await selectedImageFile!.readAsBytes()).buffer.asUint8List(),
      );

      final eventDetails = EventDetails(
        title: title,
        description: snippet, // Tutaj możesz ustawić datę wydarzenia
        eventDate: eventDate,
      );

      setState(() {
        markers.add(
          Marker(
            markerId: MarkerId(markers.length.toString()),
            position: location,
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tytuł: $title"),
                        Text("Opis: $snippet"),
                        Text("Data wydarzenia: $eventDate"),
                      ],
                    ),
                  );
                },
              );
            },
            icon: imageMarker,
          ),

        );
        eventDetailsMap[location] = eventDetails;
        isAddingMarker = false;
        selectedImageFile = null; // Usuń wybrany obraz po dodaniu znacznika
      });
    }
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
          markers: Set<Marker>.from(markers),
              onTap: (LatLng latLng) {
                if (isAddingMarker) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarkerDetailsScreen(
                        onMarkerSaved: (title, snippet, imageFile, selectedEvent, eventDate ) {
                          if (title.isNotEmpty && snippet.isNotEmpty && imageFile != null) {
                            selectedImageFile = imageFile; // Store the selected image
                            _addImageMarker(latLng, title, snippet, eventDate!);
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
