// Stateful widget to display and interact with the counter
import 'package:flutter/material.dart';
import 'package:task1_provider/CounterModel.dart';
import 'package:provider/provider.dart';

class CounterModelView extends StatefulWidget {
  const CounterModelView({super.key});

  @override
  State<CounterModelView> createState() => _CounterModelViewState();
}

// State class for CounterModelView
class _CounterModelViewState extends State<CounterModelView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter App"), // App bar title
        backgroundColor: Colors.green, // App bar background color
        foregroundColor: Colors.white, // App bar text color
      ),
      body: Center(
        child: Consumer<CounterModel>(
          builder: (context, counterModel, child) {
            return Text(
              "The value of counter is: ${counterModel.counter}", 
              style: const TextStyle(fontSize: 20), 
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green, 
        foregroundColor: Colors.white,
        onPressed: () {
          context.read<CounterModel>().incrementCounter();
        },
        child: const Icon(Icons.add), // Button icon
      ),
    );
  }
}