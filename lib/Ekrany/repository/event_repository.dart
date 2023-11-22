import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inzynierka/Ekrany/models/event_model.dart';

class EventRepository extends GetxController {
  static EventRepository get instance => Get.find();


  createEvent(EventModel event, LatLng latLng) async {
    //Dane zalogowanego uzytkownika
    String? userid = FirebaseAuth.instance.currentUser?.uid;
    if(userid == null)
    {

    }else {
      //Dodawanie do bazy danych
      HashMap<String, Object> map = HashMap();
      map["title"] = event.title;
      map["snipped"] = event.snippet;
      map["imageFile"] = event.imageFile.toString();
      map["eventType"] = event.eventType.toString();
      map["eventDate"] = event.eventDate.toString();
      map["endDate"] = event.eventEnd.toString();
      map["location"] = latLng.toString();
      map["authorUid"] = userid.toString();
      final fbapp = Firebase.app();
      final rtdb = FirebaseDatabase.instanceFor(
          app: fbapp,
          databaseURL: 'https://inzynierka-58aab-default-rtdb.europe-west1.firebasedatabase.app/');
      await rtdb.ref().child("RTDB").child("Events")
          .push()
          .update(map);
    }
  }
}
