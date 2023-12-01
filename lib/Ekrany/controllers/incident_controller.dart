import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inzynierka/Ekrany/models/event_model.dart';
import 'package:inzynierka/Ekrany/models/incident_model.dart';
import 'package:inzynierka/Ekrany/repository/event_repository.dart';
import 'package:inzynierka/Ekrany/repository/incident_repository.dart';

class IncidentController extends GetxController{
  static IncidentController get instance => Get.find();

  final incidentRepo = Get.put(IncidentRepository());

  Future<void> createIncident(IncidentModel incident) async{
    await incidentRepo.createIncident(incident);
  }
  Future<void> pullIncidents() async{
    await incidentRepo.pullIncidents();
  }
}