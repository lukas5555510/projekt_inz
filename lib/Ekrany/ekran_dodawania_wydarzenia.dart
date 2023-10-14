import 'package:flutter/material.dart';

class MarkerDetailsScreen extends StatefulWidget {
  final void Function(String title, String snippet) onMarkerSaved;
  final void Function() onMarkerCancelled;

  MarkerDetailsScreen({
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
              decoration: InputDecoration(labelText: 'Tytuł znacznika'),
            ),
            TextField(
              onChanged: (text) {
                setState(() {
                  snippet = text;
                });
              },
              decoration: InputDecoration(labelText: 'Opis znacznika'),
            ),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty && snippet.isNotEmpty) {
                  widget.onMarkerSaved(title, snippet);
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
