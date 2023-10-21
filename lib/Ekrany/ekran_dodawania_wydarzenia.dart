import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:inzynierka/Reusable_widgets/reusable_widget.dart';

class MarkerDetailsScreen extends StatefulWidget {
  final void Function(String title, String snippet, File? imageFile, String? eventType, DateTime? eventDate) onMarkerSaved;

  const MarkerDetailsScreen({
    required this.onMarkerSaved,
    Key? key, required Null Function() onMarkerCancelled,
  }) : super(key: key);


  @override
  _MarkerDetailsScreenState createState() => _MarkerDetailsScreenState();
}

class _MarkerDetailsScreenState extends State<MarkerDetailsScreen> {
  String title = '';
  String snippet = '';
  File? imageFile;
  String? eventType;
  DateTime? eventDate;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController snippetController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? selectedEvent;

  final List<String> events = ["Koncert", "Wystawa", "Festyn", "Zlot społeczności"];
  final List<String> incidents = ["Kradzież", "Wypadek", "Dzikie zwierzęta", "Bezpańskie zwierzęta"];
  bool showDateField = false;

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  final Map<String, String> eventImages = {
    "Koncert": 'lib/images/koncert.jpg',

  };

  Future<void> _loadEventImage(String eventType) async {
    final imageAssetPath = eventImages[eventType];
    if (imageAssetPath != null) {
      final byteData = await rootBundle.load(imageAssetPath);
      final buffer = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/temp_image.jpg';

      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(buffer);

      setState(() {
        imageFile = tempFile;
      });
    }
  }


  Widget _buildEventFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Data i godzina wydarzenia',
                  prefixIcon: Icon(Icons.date_range),
                ),
                enabled: false,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final selectedDateTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2101),
                );

                if (selectedDateTime != null) {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (selectedTime != null) {
                    final selectedDateTimeWithTime = DateTime(
                      selectedDateTime.year,
                      selectedDateTime.month,
                      selectedDateTime.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    setState(() {
                      eventDate = selectedDateTimeWithTime;
                      final formatter = DateFormat('yyyy-MM-dd HH:mm');
                      dateController.text = formatter.format(selectedDateTimeWithTime);
                    });
                  }
                }
              },
              child: const Text('Wybierz datę i godzinę', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        DropdownButton<String>(
          value: selectedEvent,
          items: events.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (selected) {
            setState(() {
              selectedEvent = selected;
              _loadEventImage(selected!);
            });
          },

          hint: Text('Wybierz wydarzenie'),
        ),
      ],
    );
  }

  Widget _buildIncidentFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Data incydentu',
                  prefixIcon: Icon(Icons.date_range),
                ),
                enabled: false,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final selectedDateTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2101),
                );

                if (selectedDateTime != null) {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (selectedTime != null) {
                    final selectedDateTimeWithTime = DateTime(
                      selectedDateTime.year,
                      selectedDateTime.month,
                      selectedDateTime.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    setState(() {
                      eventDate = selectedDateTimeWithTime;
                      final formatter = DateFormat('yyyy-MM-dd HH:mm');
                      dateController.text = formatter.format(selectedDateTimeWithTime);
                    });
                  }
                }
              },
              child: Text('Wybierz datę i godzinę', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        DropdownButton<String>(
          value: selectedEvent,
          items: incidents.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (selected) {
            setState(() {
              selectedEvent = selected;
            });
          },
          hint: Text('Wybierz incydent'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Szczegóły wydarzenia', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            reusableTextField('Tytuł wydarzenia', Icons.title, false, titleController),
            const SizedBox(height: 20,),
            reusableTextField('Opis wydarzenia', Icons.description, false, snippetController),
            const SizedBox(height: 10,),
            if (imageFile != null)
              Image.file(imageFile!, width: 150, height: 150),
            const SizedBox(height: 10,),
            DropdownButton<String>(
              value: eventType,
              items: ["Wydarzenie", "Incydent"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (selectedEventType) {
                setState(() {
                  eventType = selectedEventType;
                  selectedEvent = null;
                  showDateField = true;
                });
              },
              hint: Text('Wybierz rodzaj zdarzenia'),
            ),
            if (showDateField)
              eventType == 'Wydarzenie' ? _buildEventFields() : _buildIncidentFields(),
            ElevatedButton(
              onPressed: () {
                title = titleController.text;
                snippet = snippetController.text;
                if (title.isEmpty) {
                  _showSnackbar(context, 'Wprowadź tytuł znacznika');
                } else if (snippet.isEmpty) {
                  _showSnackbar(context, 'Wprowadź opis znacznika');
                } else if (eventType == null) {
                  _showSnackbar(context, 'Wybierz rodzaj zdarzenia');
                } else if (eventDate == null) {
                  _showSnackbar(context, 'Wybierz datę zdarzenia');
                } else if (selectedEvent == null) {
                  _showSnackbar(context, 'Wybierz wydarzenie lub incydent');
                } else {
                  widget.onMarkerSaved(title, snippet, imageFile, selectedEvent, eventDate);
                  Navigator.pop(context, {
                    'title': title,
                    'snippet': snippet,
                    'imageFile': imageFile,
                    'eventType': selectedEvent,
                    'eventDate': eventDate,
                  });

                }
              },
              child: const Text('Zapisz znacznik'),
            ),
            ElevatedButton(
              onPressed: () {
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