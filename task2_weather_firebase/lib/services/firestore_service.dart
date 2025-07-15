import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _weatherCollection = FirebaseFirestore.instance.collection('weather');

  Future<void> addCityWeather(String city, Map<String, dynamic> data) async {
    await _weatherCollection.doc(city).set(data);
  }

  Future<void> updateCityWeather(String city, Map<String, dynamic> data) async {
    await _weatherCollection.doc(city).update(data);
  }

  Future<void> deleteCity(String city) async {
    await _weatherCollection.doc(city).delete();
  }

  Stream<QuerySnapshot> getWeatherStream() {
    return _weatherCollection.snapshots();
  }
}
