import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:inzynierka/Ekrany/models/incident_model.dart';

class IncidentRepository extends GetxController {
  static IncidentRepository get instance => Get.find();
  createIncident(IncidentModel incident) async {
    //Dane zalogowanego uzytkownika
    String? userid = FirebaseAuth.instance.currentUser?.uid;
    if(userid == null)
    {

    }else {
      //Dodawanie do bazy danych
      HashMap<String, Object> map = HashMap();
      map["title"] = incident.title;
      map["snipped"] = incident.snippet;
      map["imageFile"] = incident.imageFile;
      map["eventType"] = incident.eventType;
      map["eventDate"] = incident.eventDate;
      map["location"] = incident.location;
      map["authorUid"] = userid.toString();
      final fbapp = Firebase.app();
      final rtdb = FirebaseDatabase.instanceFor(
          app: fbapp,
          databaseURL: 'https://inzynierka-58aab-default-rtdb.europe-west1.firebasedatabase.app/');
      await rtdb.ref().child("RTDB").child("Incidents")
          .push()
          .update(map);
    }
  }
  pullIncidents() async {
    Map<String, IncidentModel> mapa = Map();

    //Dane zalogowanego uzytkownika
    String? userid = FirebaseAuth.instance.currentUser?.uid;
    if(userid == null)
    {

    }else {
      //Pobieranie eventów z bazy danych
      final fbapp = Firebase.app();
      final rtdb = FirebaseDatabase.instanceFor(
          app: fbapp,
          databaseURL: 'https://inzynierka-58aab-default-rtdb.europe-west1.firebasedatabase.app/');
      DatabaseReference ref = rtdb.ref().child("RTDB").child("Incidents");
      await ref.get().then((snapshot){
        if(snapshot.exists) {
          Map values = snapshot.value as Map;
          values.forEach((key, value) {

            IncidentModel model = IncidentModel(
                title: value['title'],
                snippet: value['snipped'],
                imageFile: value['imageFile'],
                eventType: value['eventType'],
                location: value['location'],
                eventDate: value['eventDate'],
                authorId: value['authorUid']);

            mapa[key] = model;
          });
        }
      });

    }

    return mapa;
  }
  deleteIncident(String id) async{
    final fbapp = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(
        app: fbapp,
        databaseURL: 'https://inzynierka-58aab-default-rtdb.europe-west1.firebasedatabase.app/');
    await rtdb.ref().child("RTDB").child("Incidents").child(id).remove().then((value)=>null);
  }
}
