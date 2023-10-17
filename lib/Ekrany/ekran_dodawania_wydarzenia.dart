import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MarkerDetailsScreen extends StatefulWidget {
  final void Function(String title, String snippet, File? imageFile) onMarkerSaved; // Zaktualizowany typ funkcji
  final void Function() onMarkerCancelled;

  const MarkerDetailsScreen({
    required this.onMarkerSaved,
    required this.onMarkerCancelled,
    Key? key,
  }) : super(key: key);

  @override
  _MarkerDetailsScreenState createState() => _MarkerDetailsScreenState();
}

class _MarkerDetailsScreenState extends State<MarkerDetailsScreen> {
  String title = '';
  String snippet = '';
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Marker Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (text) {
                setState(() {
                  title = text;
                });
              },
              decoration: const InputDecoration(labelText: 'Tytuł znacznika'),
            ),
            TextField(
              onChanged: (text) {
                setState(() {
                  snippet = text;
                });
              },
              decoration: const InputDecoration(labelText: 'Opis znacznika'),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Wybierz zdjęcie z galerii'),
            ),
            if (imageFile != null)
              Image.file(imageFile!, width: 200, height: 200),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty && snippet.isNotEmpty) {
                  widget.onMarkerSaved(title, snippet, imageFile); // Przekazanie trzech argumentów
                  Navigator.pop(context);
                }
              },
              child: const Text('Zapisz znacznik'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onMarkerCancelled(); // Trigger the cancel callback
                Navigator.pop(context);
              },
              child: const Text('Anuluj'),
            ),
          ],
        ),
      ),
    );
  }
}
