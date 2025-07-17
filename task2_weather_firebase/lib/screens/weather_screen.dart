import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/firestore_service.dart';
import 'saved_cities_screen.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _controller = TextEditingController();

  Map<String, dynamic>? _weatherData;
  List<dynamic>? _forecastData;
  String? _currentCity;
  bool _isLoading = false;
  bool _signingOut = false;

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = AuthService.currentUser;
    _firestoreService.getCities().listen((cities) {
      setState(() {});
    });
  }

  Future<void> _fetchWeatherAndForecast() async {
    if (_currentCity == null || _currentCity!.isEmpty) return;

    setState(() {
      _isLoading = true;
      _weatherData = null;
      _forecastData = null;
    });

    try {
      final weather = await _weatherService.fetchWeather(_currentCity!);
      final forecast = await _weatherService.fetch5DayForecast(_currentCity!);
      setState(() {
        _weatherData = weather;
        _forecastData = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to load weather. Check city or internet.")),
      );
    }
  }

  void _onSearch() {
    setState(() {
      _currentCity = _controller.text;
    });
    _fetchWeatherAndForecast();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.black;
    final backgroundColor = Colors.grey[100];
    final cardColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Text("🌤 Weather App"),
            const Spacer(),
            if (_user != null)
              Text(
                _user!.displayName ?? _user!.email ?? "User",
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            const SizedBox(width: 8),
            _signingOut
                ? const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      setState(() => _signingOut = true);
                      await AuthService.signOut();
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search Field
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Search city...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.search), onPressed: _onSearch),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Save and View Saved buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.bookmark),
                    label: const Text("Save"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, foregroundColor: Colors.white),
                    onPressed: () async {
                      if (_currentCity?.isNotEmpty ?? false) {
                        await _firestoreService.addCity(_currentCity!);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("✅ City saved!"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.list),
                    label: const Text("View Saved"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SavedCitiesScreen(
                            onCitySelected: (city) {
                              _controller.text = city;
                              _onSearch();
                              Navigator.pop(context);
                            },
                            firestoreService: _firestoreService,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Weather card or loader
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_weatherData != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${_weatherData!['name']}, ${_weatherData!['sys']['country']}",
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${_weatherData!['main']['temp']}°C, ${_weatherData!['weather'][0]['description']}",
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Forecast cards
              if (_forecastData != null)
                SizedBox(
                  height: 160,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _forecastData!
                        .where((item) => item['dt_txt'].contains("12:00:00"))
                        .take(3)
                        .map((item) {
                          final date = item['dt_txt'].substring(0, 10);
                          final temp = item['main']['temp'];
                          final desc = item['weather'][0]['description'];
                          return Card(
                            color: Colors.black,
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              width: 120,
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(date, style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                                  const SizedBox(height: 8),
                                  Text("$temp°C", style: const TextStyle(fontSize: 16, color: Colors.white)),
                                  const SizedBox(height: 4),
                                  Text(desc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12,color: Colors.white)),
                                ],
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: _controller.text.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  _currentCity = _controller.text;
                });
                _fetchWeatherAndForecast();
              },
              backgroundColor: primaryColor,
              child: const Icon(Icons.refresh),
            ),
    );
  }
}