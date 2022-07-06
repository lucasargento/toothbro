import 'package:dp_cepillo/pages/care.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'package:camera/camera.dart';
import 'pages/start.dart';
import 'pages/play.dart';
import 'pages/congrats.dart';
import 'pages/care.dart';

late List<CameraDescription>? _cameras;

void main() async {
  // configuration and initialization of the app
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  static bool isInDetectState = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tooth Bro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: HomePage(
        cameras: _cameras!,
      ),
      routes: {
        '/home': (context) => HomePage(
              cameras: _cameras!,
            ),
        '/start': (context) => const StartPage(),
        '/play': (context) => PlayPage(
              cameras: _cameras!,
            ),
        '/congrats': (context) => const CongratsPage(),
        '/care': (context) => const CarePage(),
      },
    );
  }
}
