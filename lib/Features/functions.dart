import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;


void navigateToScreen(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.fade,
      child: screen,
    ),
  );
}

Future<void> cloudStorageUpload(String id) async{
  final pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );
  if(pickedFile != null) {
    final firebase_storage.FirebaseStorage storage = firebase_storage
        .FirebaseStorage.instance;
    String filePath = pickedFile.path;
    File file = File(filePath);
    try{
      await storage.ref('$id/${pickedFile.name}').putFile(file);
    }on firebase_core.FirebaseException catch (e){
      print(e);
    }
  }
}
/*
Future<void> cloudStorageUpload(String id, Uint8List imageData) async{

    final firebase_storage.FirebaseStorage storage = firebase_storage
        .FirebaseStorage.instance;
    try{
      await storage.ref('$id/').putData(imageData);
    }on firebase_core.FirebaseException catch (e){
      print(e);
    }
}
*/




Future<firebase_storage.ListResult> cloudStorageListResults(String id) async{
  final firebase_storage.FirebaseStorage storage = firebase_storage
      .FirebaseStorage.instance;
  firebase_storage.ListResult results = await storage.ref('$id').listAll();

  results.items.forEach((firebase_storage.Reference ref) {
    print("Found photo name: $ref");
  });

  return results;
}

Future<String> downloadURL(String imageName, String id) async{
  final firebase_storage.FirebaseStorage storage = firebase_storage
      .FirebaseStorage.instance;
String downloadURL = await storage.ref('$id/$imageName').getDownloadURL();
return downloadURL;
}