import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera_web/camera_web.dart';
import 'dart:math' as math;
import 'package:lottie/lottie.dart';
import 'package:dp_cepillo/main.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const HomePage({required this.cameras, Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? height;
  double? width;
  bool? cameraDenied;

  @override
  void initState() {
    super.initState();
    MyApp.isInDetectState = false;
    fooLoaderTimer();
  }

  void fooLoaderTimer() {
    // delay for some seconds to simulate loading screen
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushNamed(context, '/start');
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFFEFCF7),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //CameraPreview(controller!),
          Center(
            child: Container(
              height: height! * 0.45,
              width: width! * 0.8,
              child: Transform.rotate(
                  angle: -math.pi / 20,
                  child: Image.asset(
                    "images/title.png",
                  )),
            ),
          ),
          Center(
            child: Container(
              height: height! * 0.30,
              width: width! * 0.8,
              child: Transform.rotate(
                  angle: -math.pi / 20,
                  child: Image.asset(
                    "images/brush.png",
                  )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: height! * 0.1,
                width: width! * 0.6,
                child: const Text(
                  "Perez is getting ready!\n-- - - --  - - -- - - - - - --- - - --  - - -- - - - - - --- - - --  - - -- - - - - - -",
                  style: TextStyle(
                      color: Color.fromARGB(255, 58, 181, 121),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  textAlign: TextAlign.right,
                ),
              ),
              Container(
                height: height! * 0.25,
                child: Lottie.network(
                    'https://assets5.lottiefiles.com/private_files/lf30_qlswdfpz.json'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
