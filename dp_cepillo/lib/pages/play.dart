import 'package:camera/camera.dart';
import 'package:dp_cepillo/utilities/api_connector.dart';
import 'package:flutter/material.dart';
import 'package:camera_web/camera_web.dart';
import 'package:lottie/lottie.dart';
import 'package:dp_cepillo/main.dart';

class PlayPage extends StatefulWidget {
  PlayPage({required this.cameras, Key? key}) : super(key: key);
  List<CameraDescription> cameras;
  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  double? height;
  double? width;
  CameraController? controller;
  bool? cameraDenied;
  APIConnector? myConnector;
  bool? toothbrush;
  int toothbrushMissingCounter = 0;
  int toothbrushDetectedCounter = 0;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    MyApp.isInDetectState = true;
    List<CameraDescription> _cameras = widget.cameras;
    toothbrush = false;
    try {
      controller = CameraController(_cameras[0], ResolutionPreset.max);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        myConnector = APIConnector(controller: controller!);
        detectorLooper();
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              print('User denied camera access.');
              cameraDenied = true;
              break;
            default:
              print('Handle other errors.');
              cameraDenied = true;
              break;
          }
        }
      });
    } catch (e) {
      print(e);
      print("You are probably running an emulator");
    }
    super.initState();
  }

  void detectorLooper() async {
    // cals the detector api once every 1 second. image streaming is not yet
    // supported for the web in flutter so we need to send image snapshots.
    await myConnector!.detect().then((value) {
      setState(() {
        toothbrush = value;
        // im using counters to validate toothrbushes because de small version of yolo istn that accurate. // might stop detecting for some miliseconds. i only want to act in consequence if it doesnt detect // for a while --> missing counter > 5 for example
        if (value) {
          toothbrushDetectedCounter++;
          toothbrushMissingCounter = 0;
        } else {
          toothbrushMissingCounter++;
          toothbrushDetectedCounter--;
          // dont make it negative !
          if (toothbrushDetectedCounter < 0) {
            toothbrushDetectedCounter = 0;
          }
        }
      });
      decideIfGameIsOver();
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      // our detect state can change between this time delta, double check!
      MyApp.isInDetectState ? detectorLooper() : print("API calling over!");
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;
    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      print("New camera selected ${cameraController.description}");
    }
  }

  void decideIfGameIsOver() {
    if (toothbrushDetectedCounter > 10) {
      Navigator.pushNamed(context, "/congrats");
    } else if (toothbrushMissingCounter > 20) {
      Navigator.pushNamed(context, "/care");
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    print("on build: $toothbrushDetectedCounter");
    return Scaffold(
      backgroundColor: const Color(0xFFFEFCF7),
      body: controller == null || cameraDenied == true
          ? Center(
              child: Text(cameraDenied == true
                  ? "Necesitamos que permitas la camara para poder jugar! :("
                  : "Cameras dont seem to work on emulators :("))
          : Container(
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
                  SizedBox(
                    height: height! * 0.05,
                  ),
                  Container(
                    height: height! * 0.2,
                    child: Lottie.network(
                      'https://assets2.lottiefiles.com/packages/lf20_dcugqtlf.json',
                      frameRate: FrameRate.max,
                    ),
                  ),
                  toothbrushDetectedCounter > 1 &&
                          toothbrushMissingCounter <
                              5 // havent detected a toothbrush for a """while""" if that happens
                      ? Column(
                          children: [
                            Container(
                              height: height! * 0.35,
                              child: Lottie.network(
                                  'https://assets6.lottiefiles.com/private_files/lf30_vaWEhi.json',
                                  fit: BoxFit.fill),
                            ),
                            SizedBox(
                              height: height! * 0.05,
                            ),
                            Container(
                                height: height! * 0.35,
                                child: Image.asset("images/contento.png"))
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: height! * 0.05,
                            ),
                            Container(
                              height: height! * 0.35,
                              child: Lottie.network(
                                'https://assets8.lottiefiles.com/packages/lf20_mvz75ndf.json',
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                              height: height! * 0.05,
                            ),
                            Container(
                                height: height! * 0.3,
                                child: Image.asset("images/dale.png"))
                          ],
                        )
                ],
              ),
            ),
    );
  }
}
