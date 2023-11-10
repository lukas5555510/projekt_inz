class EventModel{
  final String title;
  final String snippet;
  //final File? imageFile;
  //final String? eventType;
  //final DateTime? eventDate;
  //final DateTime? eventEnd;

  const EventModel({
    required this.title,
    required this.snippet,
    //required this.imageFile,
    //required this.eventType,
    //required this.eventDate,
    //required this.eventEnd,
});

  toJSON(){
    return {
      "Title": title,
      "Snippet": snippet,
      //"ImageFile": imageFile,
      //"EventType": eventType,
      //"EventDate": eventDate,
      //"EventEnd": eventEnd,
    };
  }
}