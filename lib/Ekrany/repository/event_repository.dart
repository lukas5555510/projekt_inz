import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inzynierka/Ekrany/models/event_model.dart';

class EventRepository extends GetxController {
  static EventRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;


  createEvent(EventModel event) async {
    await _db
        .collection("events")
        .add(event.toJSON())
        .whenComplete(() => Get.snackbar(
              "Sukces",
              "Dodano event do bazy danych",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green,
            ))
        .catchError((error, stackTrace) {
      Get.snackbar(
        "Błąd",
        "Coś spadło z rowerka, spróbuj jeszcze raz",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      return error;
    });
  }
}
