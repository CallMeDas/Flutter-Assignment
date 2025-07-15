import 'package:flutter/material.dart';
import 'theme_switcher.dart';
import 'image_picker_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations & Device Features',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2), // Soft background color
      appBar: AppBar(
        title: const Text('Device Features'),
        backgroundColor: const Color.fromARGB(255, 64, 63, 65),
        foregroundColor: Colors.white,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white),
                child: const Text("🎨 Theme Animation"),
                onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ThemeSwitcher()),),),
              const SizedBox(height: 20), // Space between buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white),
                child: const Text("📷 Pick Image"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ImagePickerScreen()),
                ),),],),
        ),),);}
}


