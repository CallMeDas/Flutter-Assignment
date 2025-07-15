import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:weather_firebase_app/screens/home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAj8v14cP0NYrktYA4jY_tjddOBmyKWplY",
        authDomain: "weather-app77.firebaseapp.com",
        projectId: "weather-app77",
        storageBucket: "weather-app77.firebasestorage.app",
        messagingSenderId: "1033929961237",
        appId: "1:1033929961237:web:3c1d3c089833ffcaa8031c",
        measurementId: "G-GPVYH15QN0",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Firebase App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
