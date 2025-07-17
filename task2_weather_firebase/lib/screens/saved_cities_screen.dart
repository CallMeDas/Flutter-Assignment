import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/weather_service.dart';

class SavedCitiesScreen extends StatefulWidget {
  final void Function(String) onCitySelected;
  final FirestoreService firestoreService;

  const SavedCitiesScreen({
    super.key,
    required this.onCitySelected,
    required this.firestoreService,
  });

  @override
  State<SavedCitiesScreen> createState() => _SavedCitiesScreenState();
}

class _SavedCitiesScreenState extends State<SavedCitiesScreen> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic> _weatherMap = {};

  @override
  void initState() {
    super.initState();
    _loadWeatherForCities();
  }

  void _loadWeatherForCities() {
    widget.firestoreService.getCities().listen((cities) async {
      for (var city in cities) {
        if (!_weatherMap.containsKey(city)) {
          try {
            final weather = await _weatherService.fetchWeather(city);
            setState(() {
              _weatherMap[city] = weather;
            });
          } catch (e) {
            // ignore errors silently
          }
        }
      }
    });
  }

// void _clearAll() async {
//   final cities = await widget.firestoreService.getCities().first;
//   for (var city in cities) {
//     await widget.firestoreService.deleteCity(city);
//   }

//   if (mounted) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("🧹 All cities cleared!"),
//         duration: Duration(seconds: 2),
//       ),
//     );
//     setState(() {
//       _weatherMap.clear();
//     });
//   }
// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📌 Saved Cities"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.delete_sweep),
        //     onPressed: _clearAll,
        //     tooltip: "Clear All",
        //   )
        // ],
      ),
      body: StreamBuilder<List<String>>(
        stream: widget.firestoreService.getCities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final cities = snapshot.data ?? [];
          if (cities.isEmpty) {
            return const Center(child: Text("No saved cities."));
          }

          return ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              final weather = _weatherMap[city];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                child: ListTile(
                  title: Text(city),
                  
                  subtitle: weather != null
                      ? Text("${weather['main']['temp']}°C, ${weather['weather'][0]['description']}")
                      : const Text("Loading weather..."),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          widget.onCitySelected(city);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await widget.firestoreService.deleteCity(city);
                          setState(() {
                            _weatherMap.remove(city);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
