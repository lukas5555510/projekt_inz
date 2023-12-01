import 'dart:io';

class IncidentModel{
  final String title;
  final String snippet;
  final String imageFile;
  final String eventType;
  final String eventDate;
  final String location;
  final String? authorId;

  const IncidentModel({
    required this.title,
    required this.snippet,
    required this.imageFile,
    required this.eventType,
    required this.eventDate,
    required this.location,
    required this.authorId,
  });

  toJSON(){
    return {
      "title": title,
      "snippet": snippet,
      "imageFile": title,
      "eventType": eventType,
      "eventDate": eventDate,
      "location": location,
      "authorId": authorId,
    };
  }
}