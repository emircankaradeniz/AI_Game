import 'package:ai_game/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as flutterWidgets;

void main() {
  runApp(flutterWidgets.MaterialApp(home: MyApp()));
}

class MyApp extends flutterWidgets.StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends flutterWidgets.State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        flutterWidgets.MaterialPageRoute(builder: (context) => GamePage()),
      );
    });
  }

  @override
  flutterWidgets.Widget build(flutterWidgets.BuildContext context) {
    return flutterWidgets.Scaffold(
      body: flutterWidgets.Stack(
        children: [
          flutterWidgets.Container(
            decoration: flutterWidgets.BoxDecoration(
              image: flutterWidgets.DecorationImage(
                image: flutterWidgets.AssetImage("lib/assets/splashscreen.jpg"),
                fit: flutterWidgets.BoxFit.cover,
              ),
            ),
          ),
          flutterWidgets.Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: flutterWidgets.Padding(
              padding: flutterWidgets.EdgeInsets.symmetric(horizontal: 20.0),
              child: flutterWidgets.LinearProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
