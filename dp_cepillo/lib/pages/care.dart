import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera_web/camera_web.dart';
import 'package:lottie/lottie.dart';
import 'package:dp_cepillo/main.dart';

class CarePage extends StatefulWidget {
  const CarePage({Key? key}) : super(key: key);
  @override
  State<CarePage> createState() => _CarePageState();
}

class _CarePageState extends State<CarePage> {
  double? height;
  double? width;
  CameraController? controller;
  bool? cameraDenied;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    MyApp.isInDetectState = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFFEFCF7),
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/fondo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height! * 0.05,
            ),
            Container(
              height: height! * 0.35,
              child: Image.asset(
                "images/care.png",
                fit: BoxFit.fill,
              ),
            ),
            Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_P1hPKb.json',
                fit: BoxFit.fill,
                height: height! * 0.25),
            Lottie.network(
                'https://assets6.lottiefiles.com/packages/lf20_DQyjhI.json',
                fit: BoxFit.fill,
                height: height! * 0.35),
          ],
        ),
      ),
    );
  }
}
