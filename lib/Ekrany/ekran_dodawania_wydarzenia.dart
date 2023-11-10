//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:inzynierka/Ekrany/controllers/event_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'models/event_model.dart';
import 'package:inzynierka/Reusable_widgets/reusable_widget.dart';

class MarkerDetailsScreen extends StatefulWidget {
  final void Function(String title, String snippet, File? imageFile,
          String? eventType, DateTime? eventDate, DateTime? eventEnd)
      onMarkerSaved;

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

  Widget _buildEventFields() {
    return Column(
      children: [
        Column(
          children: [
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Data i godzina rozpoczęcia wydarzenia',
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
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        Column(
          children: [
            TextField(
              controller: endDateController,
              decoration: const InputDecoration(
                labelText: 'Data i godzina zakończenia wydarzenia',
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
                  style: TextStyle(color: Colors.white)),
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
                      final formatter = DateFormat('dd-MM-yyyy HH:mm');
                      dateController.text =
                          formatter.format(selectedDateTimeWithTime);
                    });
                  }
                }
              },
              child: Text('Wybierz datę i godzinę',
                  style: TextStyle(color: Colors.white)),
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
              _loadEventImage(selected!); // Zaktualizuj obraz dla incydentu
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
        title: const Text('Szczegóły wydarzenia',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
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
            reusableTextField(
                'Opis wydarzenia', Icons.description, false, snippetController),
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
              eventType == 'Wydarzenie'
                  ? _buildEventFields()
                  : _buildIncidentFields(),
            ElevatedButton(
              onPressed: () {
                title = titleController.text;
                snippet = snippetController.text;
                if (title.isEmpty) {
                  _showSnackbar(context, 'Wprowadź tytuł wydarzenia/incydentu');
                } else if (snippet.isEmpty) {
                  _showSnackbar(context, 'Wprowadź opis wydarzenia/incydentu');
                } else if (eventType == null) {
                  _showSnackbar(context, 'Wybierz rodzaj zdarzenia');
                } else if (eventDate == null) {
                  _showSnackbar(context, 'Wybierz datę wydarzenia/incydentu');
                } else if (selectedEvent == null) {
                  _showSnackbar(context, 'Wybierz wydarzenie lub incydent');
                } else {
                    widget.onMarkerSaved(title, snippet, imageFile,
                        eventType, eventDate, eventEnd); // Przekaż endDate
                    Navigator.pop(context, {
                      'title': title,
                      'snippet': snippet,
                      'imageFile': imageFile,
                      'eventType': eventType,
                      'eventDate': eventDate,
                      'endDate': eventEnd, // Przekaż endDate
                    });
                  //gdzies tu w okolicy dodac wysylanie do firestore podobnie jak userow
                    final event = EventModel(
                        title: controller.title.text.trim(),
                        snippet: controller.snippet.text.trim(),
                        //imageFile: imageFile,
                        //eventType: eventType,
                        //eventDate: eventDate,
                        //eventEnd: eventEnd
                    );
                    EventController.instance.createEvent(event);
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
    );
  }
}
