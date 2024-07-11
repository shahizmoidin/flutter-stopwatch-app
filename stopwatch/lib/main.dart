import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const StopwatchApp());
}

class StopwatchApp extends StatelessWidget {
  const StopwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
      ),
      home: const StatefulExample(),
    );
  }
}

class StatefulExample extends StatefulWidget {
  const StatefulExample({super.key});

  @override
  State<StatefulExample> createState() => _StatefulExampleState();
}

class _StatefulExampleState extends State<StatefulExample> {
  late int rollno;
  List<String> laps = [];
  bool isButtonEnabled = true;

  Timer? _timer;
  int _counter = 0;
  bool _isRunning = false;

  void _stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _isRunning = false;
    }
  }

  void _startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _counter++;
        });
      });
    }
  }

  @override
  void initState() {
    rollno = 10;
    super.initState();
  }

  String get formattedTime {
    final int hours = _counter ~/ 3600;
    final int minutes = (_counter % 3600) ~/ 60;
    final int seconds = _counter % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _recordLap() {
    setState(() {
      laps.add(formattedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              formattedTime,
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    isButtonEnabled ? _startTimer() : null;
                    setState(() {
                      isButtonEnabled = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                  ),
                  child: Text(
                    _counter == 0 ? "Start" : "Resume",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _stopTimer();
                    setState(() {
                      isButtonEnabled = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                  ),
                  child: const Text(
                    "Stop",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _recordLap,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                  ),
                  child: const Text(
                    "Lap",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _counter = 0;
                      laps.clear();
                      _stopTimer();
                      isButtonEnabled = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                  ),
                  child: const Text(
                    "Reset",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: laps.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white10,
                    child: ListTile(
                      title: Text(
                        'Lap ${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        laps[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
