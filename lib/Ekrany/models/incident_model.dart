import 'dart:io';

class IncidentModel{
  final String title;
  final String snippet;
  final File? imageFile;
  final String? eventType;
  final DateTime? eventDate;

  const IncidentModel({
    required this.title,
    required this.snippet,
    required this.imageFile,
    required this.eventType,
    required this.eventDate,
  });

  toJSON(){
    return {
      "Title": title,
      "Snippet": snippet,
      "ImageFile": title,
      "EventType": eventType,
      "EventDate": eventDate,
    };
  }
}