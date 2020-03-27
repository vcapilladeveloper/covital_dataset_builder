//import 'package:flutter/material.dart';
//import 'package:camera/camera.dart';
//import 'package:image/image.dart' as imglib;
import 'package:flutter/scheduler.dart';
import 'user_data_container.dart';
//import 'O2process.dart';


import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class CameraExampleHome extends StatefulWidget {
  @override
  _CameraExampleHomeState createState() {
    return _CameraExampleHomeState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraExampleHomeState extends State<CameraExampleHome>
    with WidgetsBindingObserver {
  CameraController controller;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  void _initializeApp() async {
    var cameras = UserDataContainer
        .of(context)
        .data
        .cameras;
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Camera example'),
      ),
      body: Column(
        children: <Widget>[

          IconButton(icon: Icon(Icons.videocam),
          onPressed: (){


            controller.dispose();

            Navigator.of(context).pushNamed('/video');

          },),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: controller != null && controller.value.isRecordingVideo
                      ? Colors.redAccent
                      : Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),
          _captureControlRowWidget(),
          _toggleAudioWidget(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _cameraTogglesRowWidget(),
                _thumbnailWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  /// Toggle recording audio
  Widget _toggleAudioWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Row(
        children: <Widget>[
          const Text('Enable Audio:'),
          Switch(
            value: enableAudio,
            onChanged: (bool value) {
              enableAudio = value;
              if (controller != null) {
                onNewCameraSelected(controller.description);
              }
            },
          ),
        ],
      ),
    );
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            videoController == null && imagePath == null
                ? Container()
                : SizedBox(
              child: (videoController == null)
                  ? Image.file(File(imagePath))
                  : Container(
                child: Center(
                  child: AspectRatio(
                      aspectRatio:
                      videoController.value.size != null
                          ? videoController.value.aspectRatio
                          : 1.0,
                      child: VideoPlayer(videoController)),
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink)),
              ),
              width: 64.0,
              height: 64.0,
            ),
          ],
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: controller != null &&
              controller.value.isInitialized &&
              !controller.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: controller != null &&
              controller.value.isInitialized &&
              !controller.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: controller != null && controller.value.isRecordingPaused
              ? Icon(Icons.play_arrow)
              : Icon(Icons.pause),
          color: Colors.blue,
          onPressed: controller != null &&
              controller.value.isInitialized &&
              controller.value.isRecordingVideo
              ? (controller != null && controller.value.isRecordingPaused
              ? onResumeButtonPressed
              : onPauseButtonPressed)
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: controller != null &&
              controller.value.isInitialized &&
              controller.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        )
      ],
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];


    var cameras = UserDataContainer
        .of(context)
        .data
        .cameras;

    if (cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      for (CameraDescription cameraDescription in cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: controller?.description,
              value: cameraDescription,
              onChanged: controller != null && controller.value.isRecordingVideo
                  ? null
                  : onNewCameraSelected,
            ),
          ),
        );
      }
    }

    return Row(children: toggles);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          videoController?.dispose();
          videoController = null;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      if (filePath != null) showInSnackBar('Saving video to $filePath');
    });
  }

  void onStopButtonPressed() {



    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recorded to: $videoPath');

      UserDataContainer.of(context).data.last_video = videoPath;



      print("Stopped");

    });

  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording resumed');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();
  }

  Future<void> pauseVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
    VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CameraExampleHome();
  }
}





//
//
//class Camera extends StatefulWidget {
//
//  Camera();
//
//  @override
//  _CameraState createState() => new _CameraState();
//}
//
//class _CameraState extends State<Camera> {
//  CameraController controller;
//  bool isDetecting = false;
//  double redavg;
//  imglib.Image last_image;
//  int count = 0;
//
//  DateTime last_frame = DateTime.now();
//
//  CameraImage _last_cam;
//
//  O2Process o2 = O2Process();
//
//  Image _image_display;
//
//  @override
//  void initState() {
//    super.initState();
//    SchedulerBinding.instance.addPostFrameCallback((_) {
//      _initializeApp();
//    });
//  }
//
//  void _initializeApp() async {
//    var cameras = UserDataContainer.of(context).data.cameras;
//    if (cameras == null || cameras.length < 1) {
//      print('No camera is found');
//    } else {
//      controller = new CameraController(
//        cameras[0],
//        ResolutionPreset.high,
//      );
//      controller.initialize().then((_) {
//        if (!mounted) {
//          return;
//        }
//        setState(() {});
//
//        controller.startImageStream((CameraImage img) async {
//
//          _last_cam = img;
//          Duration time = new DateTime.now().difference(last_frame);
//          print("lf " + last_frame.toString() + "fps: " + (1 / (time.inMilliseconds/1000)).toString());
//          last_frame = new DateTime.now();
////          setState(() {
////
////          });
//////          print(count.toString() + "Stream. detecting: " + isDetecting.toString());
////          if (!isDetecting) {
////            isDetecting = true;
////
////            int startTime = new DateTime.now().millisecondsSinceEpoch;
////            _processCameraImage(img);
////            int endTime = new DateTime.now().millisecondsSinceEpoch;
////
////            print("Detection done in " + (endTime - startTime).toString() + " and we have " + o2.redAvgList.length.toString() + " elements");
//////            isDetecting = false;
////          }
////          else{
////            count = count + 1;
////            if(count >= 0){
////              count = 0;
////              isDetecting = false;
////            }
////            print("It's detecting");
////          }
////
////          Duration time = new DateTime.now().difference(last_frame);
////          print("lf " + last_frame.toString() + "fps: " + (1 / (time.inMilliseconds/1000)).toString());
////          last_frame = new DateTime.now();
//
//        });
//      });
//    }
//  }
//
//  @override
//  void dispose() {
//    controller?.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (controller == null || !controller.value.isInitialized) {
//      return Container();
//    }
//
//
//    return
//
//      Scaffold(
//        body: Column(
//          children: <Widget>[
//            Text("red: "+ redavg.toString() + " "+ count.toString()),
////            Expanded(child: CameraPreview(controller)),
//          ],
//        ),
//      );
//
////    );
//  }
//
//  void _processCameraImage(CameraImage image) async {
//    count = count +1;
////    print("p: " + image.planes.length.toString());
////    if (isDetecting) {
////      print("Already detecting;");
////      return;
////    }
////    else{
////      isDetecting = true;
//      try {
//        await processFrame(image);
//      } catch (e) {
//        // await handleExepction(e)
//      } finally {
//        print("Done detecting :)");
////        isDetecting = false;
//      }
////    }
//
//
//
//  }
//
//  void processFrame(CameraImage image) async {
//    print ("convert");
//
//    int ret = await o2.processFrameCamera(image);
//    assert(ret != -1);
//
//
//    if(o2.redAvgList.length == 30){
//      print("Clearing the test");
//      o2.redAvgList.clear();
//    }
//
//    setState(() {
////      redavg = colors[2];
////      print(colors.toString());
//    });
//  }
//
//
//  imglib.Image _convertCameraImage(CameraImage image) {
//
//    int r_sum = 0;
//    int b_sum = 0;
//    int g_sum = 0;
//
//    int width = image.width;
//    int height = image.height;
//    var img = imglib.Image(image.planes[0].bytesPerRow, height); // Create Image buffer
//    const int hexFF = 0xFF000000;
//    final int uvyButtonStride = image.planes[1].bytesPerRow;
//    final int uvPixelStride = image.planes[1].bytesPerPixel;
//    for (int x = 0; x < width; x++) {
//      for (int y = 0; y < height; y++) {
//        final int uvIndex =
//            uvPixelStride * (x / 2).floor() + uvyButtonStride * (y / 2).floor();
//        final int index = y * width + x;
//        final yp = image.planes[0].bytes[index];
//        final up = image.planes[1].bytes[uvIndex];
//        final vp = image.planes[2].bytes[uvIndex];
//        // Calculate pixel color
//        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
//        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
//            .round()
//            .clamp(0, 255);
//        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
//        // color: 0x FF  FF  FF  FF
//        //           A   B   G   R
//        img.data[index] = hexFF | (b << 16) | (g << 8) | r;
//
//        r_sum = r_sum + r;
//        b_sum = b_sum + b;
//        g_sum = g_sum + g;
//      }
//    }
//    // Rotate 90 degrees to upright
////    var img1 = imglib.copyRotate(img, 90);
//
//    imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
//    // Convert to png
//    List<int> png = pngEncoder.encodeImage(img);
//    _image_display = Image.memory(png);
//
//    print("rgb: " + r_sum.toString() + " " + b_sum.toString() + " " + g_sum.toString());
//
//    return img;
//  }
//
//}
//
//
//
