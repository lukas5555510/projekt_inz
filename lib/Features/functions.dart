import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

Future<void> cloudStorageUploadDefault(String id, XFile? file) async{
  final pickedFile = file;
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

Future<Map<String, String>> getImagesFromCloudStorage() async {
  Map<String, String> imageMap = {};
  final firebase_storage.FirebaseStorage storage = firebase_storage
      .FirebaseStorage.instance;
  try {
    final firebase_storage.ListResult result = await storage.ref('default/').listAll();
    final List<firebase_storage.Reference> allImages = result.items;

    for (var imageReference in allImages) {
      final imageUrl = await imageReference.getDownloadURL();
      // Przykładowe przypisanie nazwy pliku jako klucz w mapie
      imageMap[imageReference.name] = imageUrl;
    }
  } catch (e) {
    print('Error getting images from cloud storage: $e');
  }

  return imageMap;
}
Future<Map<String, Uint8List>> getIconsFromCloudStorage() async {
  Map<String, Uint8List> iconMap = {};

  try {
    final firebase_storage.ListResult result = await firebase_storage.FirebaseStorage.instance.ref("default/").listAll();
    final List<firebase_storage.Reference> allImages = result.items;

    for (var imageReference in allImages) {
      final imageUrl = await imageReference.getDownloadURL();
      final Uint8List icon = await _createCustomIcon(imageUrl);

      // Przykładowe przypisanie nazwy pliku jako klucz w mapie
      iconMap[imageReference.name] = icon;
    }
  } catch (e) {
    print('Error getting icons from cloud storage: $e');
  }

  return iconMap;
}

Future<Uint8List> _createCustomIcon(String imageUrl) async {
  // Pobierz obraz z adresu URL
  final ByteData data = await NetworkAssetBundle(Uri.parse(imageUrl)).load('');
  final Uint8List bytes = data.buffer.asUint8List();

  // Przekształć obraz na BitmapDescriptor

  return bytes;
}