import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:inzynierka/Reusable_widgets/reusable_widget.dart';

class MarkerDetailsScreen extends StatefulWidget {
  final void Function(String title, String snippet, File? imageFile) onMarkerSaved;
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
  final TextEditingController titleController = TextEditingController();
  final TextEditingController snippetController = TextEditingController();

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey, // Zmień kolor tła
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Szczegóły wydarzenia', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView( // Dodaj SingleChildScrollView
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            reusableTextField('Tytuł znacznika', Icons.title, false, titleController),
            const SizedBox(height: 20,),
            reusableTextField('Opis znacznika', Icons.description, false, snippetController),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Wybierz zdjęcie z galerii'),
            ),
            if (imageFile != null)
              Image.file(imageFile!, width: 200, height: 200),
            ElevatedButton(
              onPressed: () {
                title = titleController.text;
                snippet = snippetController.text;
                if (title.isEmpty) {
                  _showSnackbar(context, 'Wprowadź tytuł znacznika');
                } else if (snippet.isEmpty) {
                  _showSnackbar(context, 'Wprowadź opis znacznika');
                } else if (imageFile == null) {
                  _showSnackbar(context, 'Dodaj zdjęcie znacznika');
                } else {
                  widget.onMarkerSaved(title, snippet, imageFile);
                  Navigator.pop(context);
                }
              },
              child: const Text('Zapisz znacznik'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onMarkerCancelled();
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
