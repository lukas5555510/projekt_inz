import 'dart:io';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inzynierka/Ekrany/models/event_model.dart';
import 'package:inzynierka/Ekrany/repository/event_repository.dart';



class EventController extends GetxController{
  static EventController get instance => Get.find();

  final eventRepo = Get.put(EventRepository());

  Future<void> createEvent(EventModel event) async{
    await eventRepo.createEvent(event);
  }
  Future pullEvents() async{
    return await eventRepo.pullEvents();
  }
  Future deleteEvent(String id)async{
    await eventRepo.deleteEvent(id);
  }
  Future addLike(String id)async{
    await eventRepo.addLike(id);
  }
  Future removeLike(String id)async{
    await eventRepo.removeLike(id);
  }
  Future checkLikes(String id) async{
    return await eventRepo.checkLikes(id);
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