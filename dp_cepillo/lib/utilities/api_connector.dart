import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera_web/camera_web.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dp_cepillo/main.dart';

class APIConnector {
  APIConnector({required this.controller});
  CameraController controller;

  bool decide(var response) {
    // returns true if a toothbrush is detected by our yolov5 API, the state of
    // the app will be updated upon this value.
    if (response.body.contains("toothbrush")) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> detect() async {
    /*
    Triggers an API call to the backend and sends a snapshot of the camera. 
    if the response contains a detection of a toothbrush, then take action to update the UI.
    it only makes the call if we are at "detect state", only true when in game page.
    */
    Future<bool> returnable =
        controller.takePicture().then((XFile? file) async {
      try {
        var url = Uri.parse('https://dpcepillo.herokuapp.com/object-to-json');
        var imgPath = file!.path;
        http.Response imageResponse = await http.get(
          Uri.parse(imgPath),
        );
        var bytes = base64.encode(imageResponse.bodyBytes);
        var response = await http.post(
          url,
          body: {'file': bytes},
          //headers: {"Access-Control-Allow-Origin": "*"},!!
        );
        print(response.body);
        print("hay un cepillo? ${decide(response)}");
        bool detected = decide(response);
        return detected;
      } catch (e) {
        print("Something went wrong: $e");
        return false;
      }
    });
    return returnable;
  }
}
