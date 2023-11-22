import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inzynierka/Ekrany/models/event_model.dart';
import 'package:inzynierka/Ekrany/repository/event_repository.dart';

class EventController extends GetxController{
  static EventController get instance => Get.find();

  final eventRepo = Get.put(EventRepository());

  Future<void> createEvent(EventModel event, LatLng latLng) async{
    await eventRepo.createEvent(event, latLng);
  }


}