// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

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
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      if (event.x > 2.0 || event.y > 2.0 || event.z > 2.0) {
        if (stopwatch.isRunning) {
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
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _gyroscopeSubscription?.cancel();
    weightController.dispose();
    heightController.dispose();
    stopwatch.stop();
    timer?.cancel();
  }

  void resetStepCount() {
    setState(() {
      stepCount = 0;
      totalDistance = 0.0;
      totalCalories = 0.0;
      stopwatch.reset();
    });
  }

  void startTimer() {
    setState(() {
      stopwatch.start();
      timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        setState(() {});
      });
    });
  }

  void stopTimer() {
    setState(() {
      stopwatch.stop();
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: Text(
          'Step Tracker',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto', // Ganti dengan font yang diinginkan
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 149, 219, 254),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 16.0), // Tambahkan padding top di sini
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 149, 219, 254),
                              Color.fromARGB(255, 211, 248, 255),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                '$stepCount',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Icon(
                                Icons.directions_walk,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 214, 236, 248),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 214, 236, 248),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Color.fromARGB(255, 175, 221, 244),
                    child: Text(
                      '${stopwatch.elapsed.inHours.toString().padLeft(2, '0')}:${(stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 180,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF7dcfb6),
                              Colors.white,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.outdoor_grill),
                            SizedBox(height: 8),
                            Text(
                              'Total Distance',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '${totalDistance.toStringAsFixed(2)} Km',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 180,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFF79256), // #f79256
                              Colors.white,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.local_fire_department),
                            SizedBox(height: 8),
                            Text(
                              'Total Calories',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '${totalCalories.toStringAsFixed(2)} Kcal',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: startTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7dcfb6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0),
                        ),
                        child: Text(
                          'Start',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: stopTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7dcfb6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0),
                        ),
                        child: Text(
                          'Stop',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: resetStepCount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF79256),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0),
                        ),
                        child: Text(
                          'Reset Step',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
