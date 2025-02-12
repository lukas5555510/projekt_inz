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

## Wymagania:

- Android 5.0+
- Flutter SDK

## Zrzuty ekranu

### **Proces rejestracji i logowania**  

- **Ekran powitalny**
  
  ![image](https://github.com/user-attachments/assets/de11b6ab-8f9d-414d-8629-d02dbbe8665b)

- **Ekran rejestrowania użytkownika** 
 
  ![image](https://github.com/user-attachments/assets/27bbf263-cab5-4bed-a674-cc4b874e6507)  

- **Ekran weryfikacji użytkownika**
  
  ![image](https://github.com/user-attachments/assets/59bc7e45-0edc-42eb-9a1d-f783d9133776)  

- **Email z linkiem weryfikującym konto**
  
  ![image](https://github.com/user-attachments/assets/d3d2b3f9-1bfc-4cba-a1ef-e6f5c736e9b0)  

- **Firebase authentication**
  
  ![image](https://github.com/user-attachments/assets/2dc1fcff-00d7-4d1c-8fcf-dda0c871f2a3)  

- **Ekran logowania przez maila**
 
  ![image](https://github.com/user-attachments/assets/da636f8c-2327-46ab-913b-ce7d446f633e)  

---

### **Główne ekrany aplikacji**  

- **Ekran główny z mapą**
  
  ![image](https://github.com/user-attachments/assets/335dd447-963f-4419-8404-0114b830c7f9)  

- **Panel filtrowania**
  
  ![image](https://github.com/user-attachments/assets/675d8c14-dccb-4115-9d11-5d064dde2548)  

- **Ekran główny wyświetlające tylko "Wydarzenia: Koncerty"**
  
  ![image](https://github.com/user-attachments/assets/aa4835a2-7c42-4648-a2fa-d1469f62c9f9)  

- **Ekran profilu**
  
  ![image](https://github.com/user-attachments/assets/5901c290-fdaa-4085-bd54-ca8d23bd43cc)  

---

### **Dodawanie wydarzenia**  

- **Ekran dodawania wydarzenia**
  
  ![image](https://github.com/user-attachments/assets/3e3166dd-c08c-4ceb-862a-9773b65ed3d4)  

- **Szczegóły wydarzenia**
  
  ![image](https://github.com/user-attachments/assets/06234978-189a-41ea-ac03-ae9935a3db3f)  

- **Zdjęcia dodane do wydarzenia**
  
  ![image](https://github.com/user-attachments/assets/8cc33175-d23a-49bb-b10a-a5efefb4bfb4)  

---

### **Struktura danych**  

- **Struktura bazy danych użytej do przechowywania informacji o wydarzeniach i incydentach**
  
  ![image](https://github.com/user-attachments/assets/56822132-09ca-423d-a468-27715115e7c4)  






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

