import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:inzynierka/Ekrany/models/event_model.dart';
import 'package:inzynierka/Ekrany/repository/event_repository.dart';

class EventController extends GetxController{
  static EventController get instance => Get.find();
  final title = TextEditingController();
  final snippet = TextEditingController();
  //final imageFile= TextEditingController();
 // final eventType= TextEditingController();
  //final eventDate = TextEditingController();
  //final eventEnd = TextEditingController();

  final eventRepo = Get.put(EventRepository());

  Future<void> createEvent(EventModel event) async{
    await eventRepo.createEvent(event);
  }


}