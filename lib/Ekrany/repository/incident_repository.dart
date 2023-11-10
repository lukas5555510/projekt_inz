import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inzynierka/Ekrany/models/incident_model.dart';

class IncidentRepository extends GetxController {
  static IncidentRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  createEvent(IncidentModel incident) async {
    await _db
        .collection("Incidents")
        .add(incident.toJSON())
        .whenComplete(() => Get.snackbar(
      "Sukces",
      "Dodano incydent do bazy danych",
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
      print(error.toString());
      return error;
    });
  }
}
