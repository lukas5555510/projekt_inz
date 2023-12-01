import 'dart:async';
import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inzynierka/Ekrany/models/event_model.dart';

class EventRepository extends GetxController {
  static EventRepository get instance => Get.find();


  createEvent(EventModel event) async {
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
      map["location"] = event.location.toString();
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
  pullEvents() async {
    Map<String?, Object?> mapa = Map();
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
      DatabaseReference ref = rtdb.ref().child("RTDB").child("Events");
      Map<dynamic, dynamic> eventsMap = {};
      /*
      ref.onValue.listen((event) {
        Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
        if(values !=null)
          eventsMap = values.entries
            .map((entry)=> MapEntry(entry.key, EventModel.fromMap({})))
      });
      */

      /*
      ref.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;

        if (values != null) {
          values.forEach((key, value) {
            print('Klucz: $key, Wartość: $value');
          });
        } else {
          print('Brak danych lub błąd w formacie danych w bazie.');
        }
      } as FutureOr Function(Object value)).catchError((error) {
        print('Wystąpił błąd: $error');
      });
      */

  }


}
}
