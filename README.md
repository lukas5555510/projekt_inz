# Aplikacja mobilna do udostępniania informacji o wydarzeniach i incydentach

## Opis projektu

Aplikacja mobilna umożliwia użytkownikom dodawanie, wyświetlanie i filtrowanie wydarzeń oraz incydentów na interaktywnej mapie. Dzięki temu użytkownicy mogą dzielić się informacjami na temat lokalnych wydarzeń i potencjalnych zagrożeń w swoim otoczeniu.

## Funkcjonalności

- Dodawanie wydarzeń i incydentów (nazwa, opis, lokalizacja, kategoria, data)
- Wyświetlanie wydarzeń i incydentów na mapie Google
- Możliwość filtrowania wydarzeń według kategorii
- Logowanie i rejestracja użytkowników (Google/Firebase Auth)
- Przechowywanie danych w Firebase (Firestore, Realtime Database, Storage)
- Możliwość polubienia wydarzeń/incydentów

## Technologie i Narzędzia

- **Języki:** Dart (Flutter)
- **Framework:** Flutter
- **Baza danych:** Firebase Firestore i Realtime Database
- **Mapa:** Google Maps SDK
- **Autoryzacja:** Firebase Authentication
- **Środowisko programistyczne:** Android Studio
- **Repozytorium kodu:** GitHub

## Struktura Projektu

- `lib/` - katalog główny aplikacji
- `lib/screens/` - ekrany aplikacji (logowanie, rejestracja, mapa, profil)
- `lib/models/` - modele danych (wydarzenia, incydenty, użytkownicy)
- `lib/controllers/` - logika aplikacji (zarządzanie danymi, komunikacja z Firebase)
- `lib/widgets/` - komponenty interfejsu użytkownika
- `assets/` - zasoby (ikony, obrazy)

## Instalacja i Uruchomienie

### Wymagania:

- Android 5.0+
- Flutter SDK

### Instalacja:

```sh
flutter pub get
```

### Uruchomienie aplikacji:

```sh
flutter run
```

## Zrzuty ekranu

- **Ekran główny z mapą**
- **Ekran rejestracji**
- **Ekran dodawania wydarzenia**
- **Szczegóły wydarzenia**
- **Widok bazy danych Firebase**

## Przykładowe Fragmenty Kodów

### Dodawanie wydarzenia do bazy danych:

```dart
createEvent(EventModel event) async {
  String? userid = FirebaseAuth.instance.currentUser?.uid;
  if (userid != null) {
    HashMap<String, Object> map = HashMap();
    map["title"] = event.title;
    map["snippet"] = event.snippet;
    map["eventDate"] = event.eventDate.toString();
    map["location"] = event.location.toString();
    map["authorUid"] = userid.toString();
    final rtdb = FirebaseDatabase.instance.reference();
    await rtdb.child("Events").push().update(map);
  }
}
```

### Konfiguracja Google Maps:

```dart
GoogleMap(
  mapType: MapType.normal,
  initialCameraPosition: CameraPosition(target: LatLng(0.0, 0.0), zoom: 14.0),
  myLocationEnabled: true,
  onMapCreated: (GoogleMapController controller) {
    _controller.complete(controller);
  },
  markers: Set<Marker>.from(markers),
);
```

### Pobieranie zdjęć z Firebase Storage:

```dart
Future<String> downloadURL(String imageName, String id) async {
  final storage = FirebaseStorage.instance;
  String downloadURL = await storage.ref('$id/$imageName').getDownloadURL();
  return downloadURL;
}
```

## Autorzy

- **Marcin Garbacz**
- **Łukasz Kałuszyński**

## Licencja

Projekt stworzony w ramach pracy inżynierskiej na Politechnice Lubelskiej, 2024.

