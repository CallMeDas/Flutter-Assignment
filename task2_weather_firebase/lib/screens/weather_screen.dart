import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import 'firestore_screen.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String weatherInfo = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    final data = await WeatherService().getWeather();
    setState(() {
      weatherInfo = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Info"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          )
        ],
      ),
      body: Center(
        child: Text(weatherInfo, style: const TextStyle(fontSize: 22)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FirestoreScreen())),
        label: const Text("Firestore"),
        icon: const Icon(Icons.cloud),
      ),
    );
  }
}
