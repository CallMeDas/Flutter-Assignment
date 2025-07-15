import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/weather_service.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final WeatherService _weatherService = WeatherService();
  final FirestoreService _firestoreService = FirestoreService();

  String _city = '';
  Map<String, dynamic>? _weatherData;

  void _searchWeather() async {
    if (_city.isEmpty) return;
    final data = await _weatherService.fetchWeather(_city);
    await _firestoreService.addCityWeather(_city, data);
    setState(() {
      _weatherData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather + Firebase'),
        actions: [
          IconButton(
              icon: Icon(Icons.login),
              onPressed: () async {
                final user = await _authService.signInWithGoogle();
                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Signed in as ${user.displayName}')));
                }
              }),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _authService.signOut();
              })
        ],
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Enter city'),
            onChanged: (val) => _city = val,
          ),
          ElevatedButton(onPressed: _searchWeather, child: Text("Search")),
          if (_weatherData != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "${_weatherData!['name']}: ${_weatherData!['main']['temp']}°C, ${_weatherData!['weather'][0]['description']}"),
            ),
          Expanded(
            child: StreamBuilder(
              stream: _firestoreService.getWeatherStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final docs = snapshot.data!.docs;
                return ListView(
                  children: docs
                      .map((doc) => ListTile(
                            title: Text(doc.id),
                            subtitle: Text("${doc['main']['temp']}°C"),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _firestoreService.deleteCity(doc.id),
                            ),
                          ))
                      .toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
