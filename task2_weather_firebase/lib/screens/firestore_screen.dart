import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();}
class _FirestoreScreenState extends State<FirestoreScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Stream<List<String>> _citiesStream;
  @override
  void initState() {
    super.initState();
    _citiesStream = _firestoreService.getCities();
  }
  Future<void> _deleteCity(String city) async {
    await _firestoreService.deleteCity(city);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("🗑️ Deleted $city")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Cities'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<String>>(
        stream: _citiesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No saved cities."));
          }

          final cities = snapshot.data!;
          return ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              return ListTile(
                title: Text(city),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCity(city),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
