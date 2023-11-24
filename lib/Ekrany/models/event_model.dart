class EventModel{
  final String title;
  final String snippet;
  final String imageFile;
  final String eventType;
  final String location;
  final String eventDate;
  final String eventEnd;
  final String? authorId;

  const EventModel({
    required this.title,
    required this.snippet,
    required this.imageFile,
    required this.eventType,
    required this.location,
    required this.eventDate,
    required this.eventEnd,
    required this.authorId
});

  toJSON(){
    return {
      "title": title,
      "snippet": snippet,
      "imageFile": imageFile,
      "eventType": eventType,
      "location":location,
      "eventDate": eventDate,
      "eventEnd": eventEnd,
      "authorId":authorId
    };
  }
  static EventModel fromMap(Map<String,dynamic> map){
return EventModel(
    title: map['title'],
    snippet: map['snippet'],
    imageFile: map['imageFile'],
    eventType: map['eventType'],
    location: map['location'],
    eventDate: map['eventDate'],
    eventEnd: map['eventEnd'],
    authorId: map['authorId']);
  }


}