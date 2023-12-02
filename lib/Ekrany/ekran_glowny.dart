import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:inzynierka/Ekrany/ekran_profilu.dart';
import 'package:inzynierka/Ekrany/ekran_ustawie%C5%84.dart';
import 'package:location/location.dart';
import 'controllers/event_controller.dart';
import 'ekran_dodawania_wydarzenia.dart';
import 'package:image/image.dart' as img;
import 'package:inzynierka/Features/functions.dart';

import 'models/event_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class EventDetails {
  final String title;
  final String description;
  final DateTime eventDate;
  final DateTime eventEnd;

  EventDetails({
    required this.title,
    required this.description,
    required this.eventDate,
    required this.eventEnd,
  });
}

class EventDetailsIncident {
  final String title;
  final String description;
  final DateTime eventDate;

  EventDetailsIncident({
    required this.title,
    required this.description,
    required this.eventDate,
  });
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng? _latLng;
  final eventController = Get.put(EventController());
  CameraPosition? _kGooglePlex;
  List<Marker> markers = [];
  String? markerTitle;
  String? markerSnippet;
  bool isAddingMarker = false;
  File? selectedImageFile; // Przechowuje wybrany obraz
  Map<LatLng, EventDetails> eventDetailsMap = {};
  Map<LatLng, EventDetailsIncident> eventDetailsMapIncident = {};

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(51.2362765276371, 22.58917608263832),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  Future<void> loadEventsFromDatabase() async {
    try {
      final events = await eventController.pullEvents();
      markers.clear();
      eventDetailsMap.clear();
      eventDetailsMapIncident.clear();

      events.forEach((key, value) {
        final location = eventController.stringToLatLng(value.location);
        if (value.eventType == 'Wydarzenie' && value.eventEnd != null) {
          _addImageMarker(
            location,
            value.title,
            value.snippet,
            DateTime.parse(value.eventDate),
            DateTime.parse(value.eventEnd!),
            File(value.imageFile),
          );
        } else if (value.eventType == 'Incydent') {
          _addImageMarkerIncident(
            location,
            value.title,
            value.snippet,
            DateTime.parse(value.eventDate),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      });
    } catch (e) {
      print('Error loading events: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    loadEventsFromDatabase();
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

  Future<void> _addImageMarkerIncident(
    LatLng location,
    String title,
    String snippet,
    DateTime eventDate,
  ) async {
    var selectedImageFile = this.selectedImageFile;
    if (selectedImageFile != null) {
      final img.Image originalImage =
          img.decodeImage(selectedImageFile.readAsBytesSync())!;

      const int targetWidth = 200; // Dostosuj szerokość
      const int targetHeight = 200; // Dostosuj wysokość

      final img.Image resizedImage = img.copyResize(originalImage,
          width: targetWidth, height: targetHeight);

      final BitmapDescriptor imageMarker = BitmapDescriptor.fromBytes(
          Uint8List.fromList(img.encodePng(resizedImage)));

      final eventDetailsIncident = EventDetailsIncident(
        title: title,
        description: snippet,
        eventDate: eventDate,
      );
      final formattedEventDate = eventDate.toString().substring(0, 16);

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
                        ListTile(
                          leading: const Icon(Icons.title),
                          title: Text(
                            "Tytuł: $title",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(
                            "Opis: $snippet",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.event),
                          title: Text(
                            "Data incydentu: $formattedEventDate",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: imageMarker,
          ),
        );
        eventDetailsMapIncident[location] = eventDetailsIncident;
        isAddingMarker = false;
        selectedImageFile = null; // Usuń wybrany obraz po dodaniu znacznika
      });
    }
  }

  Future<void> _addImageMarker(LatLng location, String title, String snippet,
      DateTime eventDate, DateTime eventEnd, File? image) async {
    var selectedImageFile = image;
    if (selectedImageFile != null) {
      final img.Image originalImage =
          img.decodeImage(selectedImageFile.readAsBytesSync())!;

      const int targetWidth = 200; // Dostosuj szerokość
      const int targetHeight = 200; // Dostosuj wysokość

      final img.Image resizedImage = img.copyResize(originalImage,
          width: targetWidth, height: targetHeight);

      final BitmapDescriptor imageMarker = BitmapDescriptor.fromBytes(
          Uint8List.fromList(img.encodePng(resizedImage)));

      final eventDetails = EventDetails(
        title: title,
        description: snippet,
        eventDate: eventDate,
        eventEnd: eventEnd,
      );
      final formattedEventDate = eventDate.toString().substring(0, 16);
      final formattedEventEnd = eventEnd.toString().substring(0, 16);

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
                        ListTile(
                          leading: const Icon(Icons.title),
                          title: Text(
                            "Tytuł: $title",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(
                            "Opis: $snippet",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.event),
                          title: Text(
                            "Data wydarzenia: $formattedEventDate",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.event_available),
                          title: Text(
                            "Data zakończenia wydarzenia: $formattedEventEnd",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
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
        bottomNavigationBar: GNav(
          backgroundColor: Colors.green,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.lightGreen,
          gap: 8,
          padding: EdgeInsets.all(20),
          selectedIndex: 0,
          tabs: [
            GButton(
              icon: Icons.map,
              text: "Mapa",
              onPressed: () {
                navigateToScreen(context, const MapScreen());
              },
            ),
            GButton(
              icon: Icons.person,
              text: "Profil",
              onPressed: () {
                navigateToScreen(context, const ProfileScreen());
              },
            ),
          ],
        ),
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
              zoomControlsEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(14.0, 19.0),
              onTap: (LatLng latLng) {
                if (isAddingMarker) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FutureBuilder(
                          future: eventController.pullEvents(),
                          builder: (context, snapshot) {
                            return MarkerDetailsScreen(
                              onMarkerSaved: (title, snippet, imageFile,
                                  eventType, eventDate, eventEnd) {
                                if (title.isNotEmpty &&
                                    snippet.isNotEmpty &&
                                    imageFile != null) {
                                  selectedImageFile = imageFile;
                                  if (eventType == 'Wydarzenie' &&
                                      eventEnd != null) {
                                    // Dodaj wydarzenie z datą zakończenia
                                    EventModel event_model = EventModel(
                                      title: title,
                                      snippet: snippet,
                                      imageFile: imageFile.path,
                                      eventType: eventType.toString(),
                                      location: latLng.toString(),
                                      eventDate: eventDate.toString(),
                                      eventEnd: eventEnd.toString(),
                                      authorId: FirebaseAuth
                                          .instance.currentUser?.uid
                                          .toString(),
                                    );
                                    EventController.instance
                                        .createEvent(event_model);
                                    _addImageMarker(latLng, title, snippet,
                                        eventDate!, eventEnd, imageFile);
                                  } else {
                                    // Dodaj incydent (bez daty zakończenia)
                                    _addImageMarkerIncident(
                                        latLng, title, snippet, eventDate!);
                                  }
                                }
                              },
                              onMarkerCancelled: () {
                                //setState(() {
                                isAddingMarker = false;
                                //});
                              },
                            );
                          }),
                    ),
                  );
                }
              },
            ),

            //=====
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
