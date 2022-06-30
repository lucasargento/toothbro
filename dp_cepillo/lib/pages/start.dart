import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera_web/camera_web.dart';
import 'package:lottie/lottie.dart';
import 'package:dp_cepillo/main.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
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
          children: [
            Container(
                height: height! * 0.5,
                child: Image.asset("images/getready.png")),
            SizedBox(
              height: height! * 0.1,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/play"),
              style: ElevatedButton.styleFrom(
                  shadowColor: Colors.greenAccent,
                  primary: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 5,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Vamos!",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 48, 172, 112),
                      backgroundColor: Colors.transparent),
                ),
              ),
            ),
            SizedBox(
              height: height! * 0.05,
            ),
            Container(
              height: height! * 0.2,
              child: Lottie.network(
                  'https://assets2.lottiefiles.com/packages/lf20_dcugqtlf.json'),
            ),
          ],
        ),
      ),
    );
  }
}
