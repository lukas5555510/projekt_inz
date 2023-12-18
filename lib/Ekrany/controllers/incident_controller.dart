import 'dart:io';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inzynierka/Ekrany/models/incident_model.dart';
import 'package:inzynierka/Ekrany/repository/incident_repository.dart';

class IncidentController extends GetxController{
  static IncidentController get instance => Get.find();

  final incidentRepo = Get.put(IncidentRepository());

  Future<void> createIncident(IncidentModel incident) async{
    await incidentRepo.createIncident(incident);
  }
  Future pullIncidents() async{
    return await incidentRepo.pullIncidents();
  }
  Future deleteIncident(String id)async{
    await incidentRepo.deleteIncident(id);
  }
  Future addLike(String id)async{
    await incidentRepo.addLike(id);
  }
  Future removeLike(String id)async{
    await incidentRepo.removeLike(id);
  }
  Future checkLikes(String id) async{
    return await incidentRepo.checkLikes(id);
  }
  LatLng stringToLatLng(String coordinatesString) {
    // Usuwanie zbędnych znaków z ciągu znaków
    String cleanedString = coordinatesString
        .replaceAll('LatLng(', '')
        .replaceAll(')', '')
        .trim();

    // Rozdzielanie wartości na części
    List<String> parts = cleanedString.split(',');

    // Parsowanie wartości na liczby
    double latitude = double.parse(parts[0]);
    double longitude = double.parse(parts[1]);

    // Zwracanie obiektu LatLng
    return LatLng(latitude, longitude);
  }
  File convertStringToFile(String filePathString) {
    // Usunięcie nadmiarowych informacji
    String cleanedPath = filePathString.replaceAll(RegExp(r"File: '(.*)'"), r"$1");

    // Utworzenie obiektu File na podstawie oczyszczonej ścieżki
    return File(cleanedPath);

  }
}