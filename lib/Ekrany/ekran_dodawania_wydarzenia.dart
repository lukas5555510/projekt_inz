import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:inzynierka/Ekrany/controllers/event_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:inzynierka/Reusable_widgets/reusable_widget.dart';

class MarkerDetailsScreen extends StatefulWidget {
  final void Function(String title, String snippet, File? imageFile,
      String? eventType, DateTime? eventDate, DateTime? eventEnd) onMarkerSaved;

  const MarkerDetailsScreen({
    required this.onMarkerSaved,
    Key? key,
    required Null Function() onMarkerCancelled,
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
  DateTime? eventEnd;
  LatLng? location;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController snippetController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  String? selectedEvent;

  final controller = Get.put(EventController());

  final List<String> events = [
    "Koncert",
    "Wystawa",
    "Festyn",
    "Zlot społeczności"
  ];
  final List<String> incidents = [
    "Kradzież",
    "Wypadek",
    "Dzikie zwierzęta",
    "Bezpańskie zwierzęta"
  ];
  bool showDateField = false;

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  final Map<String, String> eventImages = {
    "Koncert": 'lib/images/koncert.png',
    "Kradzież": 'lib/images/kradzież.jpg',
    "Wystawa": 'lib/images/wystawa.png',
    "Festyn": 'lib/images/festyn.png',
    "Zlot społeczności": 'lib/images/zlot.png',
    "Wypadek": 'lib/images/wypadek.png',
    "Dzikie zwierzęta": 'lib/images/dzikie_zwierzeta.png',
    "Bezpańskie zwierzęta": 'lib/images/bezpanskie_zwierzeta.png',
  };

  Future<void> _loadEventImage(String eventType) async {
    final imageAssetPath = eventImages[eventType];
    if (imageAssetPath != null) {
      final byteData = await rootBundle.load(imageAssetPath);
      final buffer = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final tempFilePath =
          '${tempDir.path}/temp_image_$eventType.jpg'; // Użyj rodzaju zdarzenia lub incydentu w nazwie pliku

      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(buffer);

      setState(() {
        imageFile = tempFile;
      });
    }
  }
  Widget _buildImageSelection() {
    return Column(
      children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );

                  if (pickedFile != null) {
                    setState(() {
                      imageFile = File(pickedFile.path);
                    });
                  }
                },
                child: const Text('Wybierz zdjęcie z galerii',
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildEventFields() {
    return Column(
      children: [
        Column(
          children: [
            _buildImageSelection(),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Data i godzina rozpoczęcia wydarzenia',
                labelStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.date_range),
              ),
              enabled: false,
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
                      final formatter = DateFormat('dd-MM-yyyy HH:mm');
                      dateController.text =
                          formatter.format(selectedDateTimeWithTime);
                    });
                  }
                }
              },
              child: const Text('Wybierz datę i godzinę rozpoczęcia',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        Column(
          children: [
            TextField(
              controller: endDateController,
              decoration: const InputDecoration(
                labelText: 'Data i godzina zakończenia wydarzenia',
                labelStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(Icons.date_range),
              ),
              enabled: false,
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
                      eventEnd = selectedDateTimeWithTime;
                      final formatter = DateFormat('dd-MM-yyyy HH:mm');
                      endDateController.text =
                          formatter.format(selectedDateTimeWithTime);
                    });
                  }
                }
              },
              child: const Text('Wybierz datę i godzinę zakończenia',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        DropdownButton<String>(
          value: selectedEvent,
          items: events.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.black)),
            );
          }).toList(),
          onChanged: (selected) {
            setState(() {
              selectedEvent = selected;
              _loadEventImage(selected!);
            });
          },
          hint: const Text('Wybierz wydarzenie', style: TextStyle(color: Colors.black)),
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
                decoration: const InputDecoration(
                  labelText: 'Data incydentu',
                  labelStyle: TextStyle(color: Colors.black),
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
                      final formatter = DateFormat('dd-MM-yyyy HH:mm');
                      dateController.text =
                          formatter.format(selectedDateTimeWithTime);
                    });
                  }
                }
              },
              child: Text('Wybierz datę i godzinę',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        DropdownButton<String>(
          value: selectedEvent,
          items: incidents.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.black)),
            );
          }).toList(),
          onChanged: (selected) {
            setState(() {
              selectedEvent = selected;
              _loadEventImage(selected!); // Zaktualizuj obraz dla incydentu
            });
          },
          hint: Text('Wybierz incydent', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Szczegóły wydarzenia',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.black],
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              reusableTextField(
                  'Tytuł wydarzenia', Icons.title, false, titleController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField('Opis wydarzenia', Icons.description, false,
                  snippetController),
              const SizedBox(
                height: 10,
              ),
              if (imageFile != null)
                Image.file(imageFile!, width: 150, height: 150),
              const SizedBox(
                height: 10,
              ),
              DropdownButton<String>(
                value: eventType,
                items: ["Wydarzenie", "Incydent"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (selectedEventType) {
                  setState(() {
                    eventType = selectedEventType;
                    selectedEvent = null;
                    showDateField = true;
                  });
                },
                hint: Text('Wybierz rodzaj zdarzenia', style: TextStyle(color: Colors.black)),
              ),
              if (showDateField)
                eventType == 'Wydarzenie'
                    ? _buildEventFields()
                    : _buildIncidentFields(),
              ElevatedButton(
                onPressed: () {
                  title = titleController.text;
                  snippet = snippetController.text;
                  if (title.isEmpty) {
                    _showSnackbar(
                        context, 'Wprowadź tytuł wydarzenia/incydentu');
                  } else if (snippet.isEmpty) {
                    _showSnackbar(
                        context, 'Wprowadź opis wydarzenia/incydentu');
                  } else if (eventType == null) {
                    _showSnackbar(context, 'Wybierz rodzaj zdarzenia');
                  } else if (eventDate == null) {
                    _showSnackbar(context, 'Wybierz datę wydarzenia/incydentu');
                  } else if (selectedEvent == null) {
                    _showSnackbar(context, 'Wybierz wydarzenie lub incydent');
                  } else {
                    widget.onMarkerSaved(title, snippet, imageFile, eventType,
                        eventDate, eventEnd); // Przekaż endDate
                    Navigator.pop(context, {
                      'title': title,
                      'snippet': snippet,
                      'imageFile': imageFile,
                      'eventType': eventType,
                      'eventDate': eventDate,
                      'endDate': eventEnd, // Przekaż endDate
                    });
                  }
                },
                child: const Text('Zapisz wydarzenie/incydent'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Anuluj'),
              )
            ],
          ),
        ),
      ),
    );
  }
}