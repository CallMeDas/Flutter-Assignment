
import 'package:flutter/material.dart';

class CounterModel with ChangeNotifier {
  int _counter = 0; 

  CounterModel(this._counter); 

  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }
}