import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save a city for the current user
  Future<void> addCity(String cityName) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('savedCities')
          .doc(cityName)
          .set({'name': cityName, 'timestamp': Timestamp.now()});
    }
  }

  /// Get stream of saved cities for the current user
  Stream<List<String>> getCities() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedCities')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc['name'] as String).toList());
  }

  /// Delete a saved city
  Future<void> deleteCity(String cityName) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('savedCities')
          .doc(cityName)
          .delete();
    }
  }
}
