import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'screens/login_screen.dart';
import 'screens/weather_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAj8v14cP0NYrktYA4jY_tjddOBmyKWplY",
        authDomain: "weather-app77.firebaseapp.com",
        projectId: "weather-app77",
        storageBucket: "weather-app77.appspot.com",
        messagingSenderId: "1033929961237",
        appId: "1:1033929961237:web:3c1d3c089833ffcaa8031c",
        measurementId: "G-GPVYH15QN0",
      ),
    );} else {
    await Firebase.initializeApp();}
  runApp(const MyApp());}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Firebase App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,),
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginScreen()
          : const HomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/weather': (context) => const HomeScreen(),
      },);}}



