import 'package:flutter/material.dart';
import 'package:step_tracker/home.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Step Counter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StepTrackerPage(),
    );
  }
}
