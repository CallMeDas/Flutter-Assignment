import 'package:flutter/material.dart';

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final modeText = isDark ? "Dark Mode" : "Light Mode";

    return Scaffold(
      appBar: AppBar(title: const Text("Animated Theme"),
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        color: bgColor,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: textColor,
                size: 50,
              ),
              const SizedBox(height: 20),
              Text(modeText,style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),),],),),),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => isDark = !isDark),
        child: const Icon(Icons.swap_horiz),
      ),);}
}


