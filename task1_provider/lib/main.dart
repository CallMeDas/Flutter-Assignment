import 'package:flutter/material.dart';
import 'CounterModel.dart';
import 'CounterModelView.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: ChangeNotifierProvider<CounterModel>(
        create: (_) => CounterModel(0), 
        child: CounterModelView(), 
      ),
    );
  }
}

