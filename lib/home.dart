// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class StepTrackerPage extends StatefulWidget {
  @override
  _StepTrackerPageState createState() => _StepTrackerPageState();
}

class _StepTrackerPageState extends State<StepTrackerPage> {
  int stepCount = 0;
  double totalDistance = 0.0;
  double totalCalories = 0.0;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      if (event.x > 2.0 || event.y > 2.0 || event.z > 2.0) {
        setState(() {
          stepCount++;
          totalDistance = (stepCount * 0.73) / 1000;
          totalCalories = (stepCount *
                  double.parse(weightController.text) *
                  double.parse(heightController.text) *
                  25) /
              (1000 * 45 * 162.7);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _gyroscopeSubscription?.cancel();
    weightController.dispose();
    heightController.dispose();
  }

  void resetStepCount() {
    setState(() {
      stepCount = 0;
      totalDistance = 0.0;
      totalCalories = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Tracker'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Weight (kg):',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: weightController,
              onChanged: (value) {
                setState(() {
                  // Nothing to do here as the value is updated through the controller
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Height (cm):',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: heightController,
              onChanged: (value) {
                setState(() {
                  // Nothing to do here as the value is updated through the controller
                });
              },
            ),
            SizedBox(height: 32),
            Text(
              'Step Count',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$stepCount',
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 24),
            Text(
              'Total Distance',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${totalDistance.toStringAsFixed(2)} Km',
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 24),
            Text(
              'Total Calories',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${totalCalories.toStringAsFixed(2)} Kcal',
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: resetStepCount,
              child: Text('Reset Step'),
            ),
          ],
        ),
      ),
    );
  }
}
