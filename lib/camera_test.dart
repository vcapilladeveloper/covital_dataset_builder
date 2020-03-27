import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as imglib;
import 'package:flutter/scheduler.dart';
import 'user_data_container.dart';
import 'O2process.dart';


class Camera extends StatefulWidget {

  Camera();

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {

  CameraController camera;

  bool isDetecting = false;

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });

    super.initState();
  }

  void _initializeApp() async {
    var cameras = UserDataContainer
        .of(context)
        .data
        .cameras;
    if (cameras == null || cameras.length < 1) {
      print('No camera is found');
    } else {
      camera = new CameraController(
        cameras[0],
        ResolutionPreset.low,
      );
    }

    await camera.initialize();
    
    camera.startImageStream((CameraImage img){
      print("yeah");
      if(isDetecting == true) {
        return;
      }
      else{
        isDetecting = true;
        print("does something");

        isDetecting = false;

      }
    });
  }

  @override
  Widget build(BuildContext context) {

  }
}