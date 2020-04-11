import 'dart:async';

import 'DrawerOnly.dart';
import 'package:flutter/material.dart';
import 'O2process/InitCamera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/scheduler.dart';
import 'user_data_container.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:countdown/countdown.dart';

import 'package:video_player/video_player.dart';

import 'survey_lib/survey.dart';
import 'package:sensors/sensors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver, SingleTickerProviderStateMixin  {
  Survey survey;

//  List<double> _accelerometerValues;
//  List<double> _userAccelerometerValues;
//  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  VoidCallback videoPlayerListener;
  VideoPlayerController videoController;

  Timer _timer_stop_recording;

  bool camera_is_init;

  String imagePath;
  CountDown _cd;
  StreamSubscription<Duration> _sub_cd;
  CountDown _cd_recording;
  StreamSubscription<Duration> _sub_cd_recording;
  Duration _time_left = Duration(seconds: -1);
  CameraSignal camera_signal_initializer;

  CameraController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool init_process = false;
//  String videoPath;

  int time_recording_in_sec = 30;
  int time_before_recording_in_sec = 10;
  bool _loading_recording_process = false;

  int animation_duration_in_ms = 400;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
//    prepareAnimations();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      runInitTasks();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ///Setting up the animation
//  void prepareAnimations() {
//    expandController = AnimationController(
////      lowerBound: 10,
////        upperBound: 500,
//        vsync: this,
//        duration: Duration(milliseconds: 5000)
//    );
//    animation = CurvedAnimation(
//      parent: expandController,
//      curve: Curves.fastOutSlowIn,
//    );
//  }

  @protected
  Future runInitTasks() async {
    survey = UserDataContainer.of(context).data.current_survey;
    var cameras = UserDataContainer.of(context).data.cameras;

    onNewCameraSelected(cameras[0]);

  }


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
//    var bright = theme.brightness;
    String icon = 'assets/images/logo_dark.png';




    List<Widget> column = [

      AnimatedContainer(
        width: 400,
        height: init_process ? 470 : 270.0,
        duration: Duration(milliseconds: animation_duration_in_ms),
        child:InkWell(
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
          onTap: controller != null && controller.value.isInitialized == false ? () {
            onNewCameraSelected(UserDataContainer.of(context).data.cameras[0]);
          } : null,
        ),

      ),




      init_process == false || _loading_recording_process == true ? AnimatedCrossFade(
        duration: Duration(milliseconds: animation_duration_in_ms),
        firstChild: Container(child:Column(children: <Widget>[

          Image.asset("assets/tutorial.png", height: 200,),
          Center(child:Text("Completely cover the rear camera with your finger", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),

          SizedBox(height: 10),

          Center(child:Text("Wipe lens and wash hands for best results", style: TextStyle(color: Colors.grey), textAlign: TextAlign.center)),

          SizedBox(height: 30),
        ],)),
        secondChild: countDownStart(),
        crossFadeState: init_process == false ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ) : countDownRecording(),


    ];
    Widget bottom_button;





    if (init_process == false) {
//      column = generate_widgets_init();
      bottom_button = start_recording_button();
    } else if (_loading_recording_process == true) {
//      column = generate_widgets_getting_ready();
      bottom_button = stop_recording_button();
    } else {
//      column = generate_widgets_recording();
      bottom_button = stop_recording_button();
    }

//    column.insert(0,
//
//
//        AnimatedContainer(
//          width: 400,
//          height: init_process ? 470 : 270.0,
//          duration: Duration(seconds: 1),
//            child:InkWell(
//                child: Container(
//                  child: Padding(
//                    padding: const EdgeInsets.all(1.0),
//                    child: Center(
//                      child: _cameraPreviewWidget(),
//                    ),
//                  ),
//                  decoration: BoxDecoration(
//                    color: Colors.black,
//                    border: Border.all(
//                      color: controller != null && controller.value.isRecordingVideo
//                          ? Colors.redAccent
//                          : Colors.grey,
//                      width: 3.0,
//                    ),
//                  ),
//                ),
//                onTap: controller != null && controller.value.isInitialized == false ? () {
//                  onNewCameraSelected(UserDataContainer.of(context).data.cameras[0]);
//                } : null,
//              ),
//
//        )
//    );

//    column.insert(1,



//
//
//
////
////      AnimatedOpacity(
////        // If the widget is visible, animate to 0.0 (invisible).
////        // If the widget is hidden, animate to 1.0 (fully visible).
////          opacity: init_process == false ? 1.0 : 0.0,
////          duration: Duration(milliseconds: 1000),
////          // The green box must be a child of the AnimatedOpacity widget.
////          child:
////
////          Container(child:Column(children: <Widget>[
////
////            Image.asset("assets/tutorial.png", height: 200,),
////            Center(child:Text("Completely cover the rear camera with your finger", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),
////
////            SizedBox(height: 10),
////
////            Center(child:Text("Wipe lens and wash hands for best results", style: TextStyle(color: Colors.grey), textAlign: TextAlign.center)),
////
////            SizedBox(height: 30),
////          ],))),
//          );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("1 of 5: Measure with CoVital"),
      ),
      body: SafeArea(
        child: new Column(
          children: column,
//          ListTile(title: Text("Home"),
//          subtitle: Text("Data collection")),

//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Icon(Icons.thumb_up),
//              Text("Ready to start")
//            ],
//          ),

//                Expanded(
//                  child: Container(
//                    child: Padding(
//                      padding: const EdgeInsets.all(1.0),
//                      child: Center(
//                        child: _cameraPreviewWidget(),
//                      ),
//                    ),
//                    decoration: BoxDecoration(
//                      color: Colors.black,
//                      border: Border.all(
//                        color:
//                            controller != null && controller.value.isRecordingVideo
//                                ? Colors.redAccent
//                                : Colors.grey,
//                        width: 3.0,
//                      ),
//                    ),
//                  ),
//                ),

//                _cameraTogglesRowWidget(),

//            Row(
//              children: <Widget>[
//                record_button(),
//                init_process == false
//                    ? Container()
//                    : Text(_loading_recording_process
//                    ? "Get ready. Recording will start in " +
//                    _time_left.inSeconds.toString() +
//                    "s"
//                    : "Recording done in " +
//                    _time_left.inSeconds.toString() +
//                    "s")
//              ],
//            ),

//              ],
        ),
      ),
      drawer: DrawerOnly(),
      bottomNavigationBar: bottom_button,
    );
  }


  Widget countDownStart(){
    return ListTile(
      title: Text("Cover camera with finger pad."),
      subtitle: Text("Countdown: " + _time_left.inSeconds.toString() + "s",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    );
  }

  Widget countDownRecording(){
    return ListTile(
      title: Text("Stay still for: " + _time_left.inSeconds.toString() + "s",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      subtitle: Text(""),
    );
  }

//  List<Widget> generate_widgets_init() {
//    List<Widget> ret = [
//
////    ListTile(
////      title: Text(
////        "Cover camera with finger pad.",
////        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
////      ),
////      subtitle: Text(""),
////    ),
//
////    Expanded(
////      child: InkWell(
////        child: Container(
////          child: Padding(
////            padding: const EdgeInsets.all(1.0),
////            child: Center(
////              child: _cameraPreviewWidget(),
////            ),
////          ),
////          decoration: BoxDecoration(
////            color: Colors.black,
////            border: Border.all(
////              color: Colors.grey,
////              width: 3.0,
////            ),
////          ),
////        ),
////        onTap: controller != null && controller.value.isInitialized == false ? () {
////          onNewCameraSelected(UserDataContainer.of(context).data.cameras[0]);
////        } : null,
////      ),
////    ),
//
//
//
//    ];
//
////    ret.add(_cameraTogglesRowWidget());
//
////    ret.add(Row(
////      children: <Widget>[
////        record_button(),
////        init_process == false
////            ? Container()
////            : Text(_loading_recording_process
////            ? "Get ready. Recording will start in " +
////            _time_left.inSeconds.toString() +
////            "s"
////            : "Recording done in " +
////            _time_left.inSeconds.toString() +
////            "s")
////      ],
////    )
////    );
//
////    ret.add(start_recording_button());
//
//    return ret;
//  }

//  List<Widget> generate_widgets_getting_ready() {
//    List<Widget> ret = List<Widget>();
//
//
//
////    ret.add(Expanded(
////      child: Container(
////        child: Padding(
////          padding: const EdgeInsets.all(1.0),
////          child: Center(
////            child: _cameraPreviewWidget(),
////          ),
////        ),
//////        decoration: BoxDecoration(
//////          color: Colors.black,
//////          border: Border.all(
//////            color: controller != null && controller.value.isRecordingVideo
//////                ? Colors.redAccent
//////                : Colors.grey,
//////            width: 3.0,
//////          ),
//////        ),
////      ),
////    ));
//
////    ret.add(_cameraTogglesRowWidget());
//
////    ret.add(stop_recording_button());
//    ret.add(ListTile(
//      title: Text("Cover camera with finger pad."),
//      subtitle: Text("Countdown: " + _time_left.inSeconds.toString() + "s",
//          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//    ));
//
//    return ret;
//  }

//  List<Widget> generate_widgets_recording() {
//    List<Widget> ret = List<Widget>();
//
//
//
////    ret.add(
////      Expanded(
////          child: Container(
////        child: Padding(
////          padding: const EdgeInsets.all(1.0),
////          child: Center(
////            child: _cameraPreviewWidget(),
////          ),
////        ),
//////          decoration: BoxDecoration(
//////            color: Colors.black,
//////            border: Border.all(
//////              color: controller != null && controller.value.isRecordingVideo
//////                  ? Colors.redAccent
//////                  : Colors.grey,
//////              width: 3.0,
//////            ),
//////          ),
////      )),
////    );
//
//    ret.add(ListTile(
//      title: Text("Stay still for: " + _time_left.inSeconds.toString() + "s",
//          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//      subtitle: Text(""),
//    ));
//
////    ret.add(_cameraTogglesRowWidget());
//
////    ret.add(stop_recording_button());
//
//    return ret;
//  }

  Widget start_recording_button() {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Expanded(
                child: RaisedButton(
              elevation: 0,
              child: Text(
                "Start measurement",
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.title.color),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
//                expandController.forward();
                _loading_recording_process = true;
                _time_left = Duration(seconds: time_before_recording_in_sec);
                setState(() {
                  controller.flash(true);
                  init_process = true;
                });

                _cd =
                    CountDown(Duration(seconds: time_before_recording_in_sec));
                _sub_cd = _cd.stream.listen(null);
                // start your countdown by registering a listener
                _sub_cd.onData((Duration d) {
                  setState(() {
                    _time_left = d;
                  });
                });

                // when it finish the onDone cb is called
                _sub_cd.onDone(() {
                  _loading_recording_process = false;
                  onStartVideoRecording();

                  _cd_recording =
                      CountDown(Duration(seconds: time_recording_in_sec));
                  _sub_cd_recording = _cd_recording.stream.listen(null);
                  _sub_cd_recording.onData((Duration d) {
                    setState(() {
                      _time_left = d;
                    });
                  });

                  _timer_stop_recording =
                      Timer(Duration(seconds: time_recording_in_sec), () {
                    print("Stopping the recording");
                    onStopRecording();
                  });
                });
              },
            ))
          ],
        ));
  }

  Widget stop_recording_button() {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Expanded(
                child: RaisedButton(
              elevation: 0,
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.title.color),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                print("stop to record");
                setState(() {
//                  expandController.reverse();
                  _loading_recording_process = false;
                  controller.flash(false);
                  init_process = false;
                  _sub_cd?.cancel();
                  _timer_stop_recording?.cancel();

                  _sub_cd_recording?.cancel();
                  onStopRecording(was_cancelled: true);
                });
              },
            ))
          ],
        ));
  }

//  Widget record_button() {
//    return init_process == false
//        ? FlatButton(
//            child: Text("Start recording"),
//            onPressed: () {
//              print("start to record");
//              _loading_recording_process = true;
//              _time_left = Duration(seconds: time_before_recording_in_sec);
//              setState(() {
//                controller.flash(true);
//                init_process = true;
//              });
//
//              _cd = CountDown(Duration(seconds: time_before_recording_in_sec));
//              _sub_cd = _cd.stream.listen(null);
//              // start your countdown by registering a listener
//              _sub_cd.onData((Duration d) {
//                setState(() {
//                  _time_left = d;
//                });
//              });
//
//              // when it finish the onDone cb is called
//              _sub_cd.onDone(() {
//                _loading_recording_process = false;
//                onStartVideoRecording();
//
//                _cd_recording =
//                    CountDown(Duration(seconds: time_recording_in_sec));
//                _sub_cd_recording = _cd_recording.stream.listen(null);
//                _sub_cd_recording.onData((Duration d) {
//                  setState(() {
//                    _time_left = d;
//                  });
//                });
//
//                _timer_stop_recording =
//                    Timer(Duration(seconds: time_recording_in_sec), () {
//                  print("Stopping the recording");
//                  onStopRecording();
//                });
//              });
//            },
//          )
//        : FlatButton(
//            child: Text("Cancel"),
//            onPressed: () {
//              print("stop to record");
//              setState(() {
//                _loading_recording_process = false;
//                controller.flash(false);
//                init_process = false;
//                _sub_cd?.cancel();
//                _timer_stop_recording?.cancel();
//
//                _sub_cd_recording?.cancel();
//                onStopRecording(was_cancelled: true);
//              });
//            },
//          );
//  }
//
////  void start_recording(){
////    print("Start recording for 30 sec");
////  }

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

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Text(
        controller == null || controller.value.isInitialized
            ? ' Start measurements'
            : 'Tap here to enable the camera',
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

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
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

  void _showCameraException(CameraException e) {
    print(e.code + " " + e.description);
    showInSnackBar('${e.description}\nCamera is disabled inside App settings');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    var cameras = UserDataContainer.of(context).data.cameras;

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

  void onStartVideoRecording() {
    //Start recording sensor measurements.
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        survey.accelerometerValues.add(event.x);
        survey.accelerometerValues.add(event.y);
        survey.accelerometerValues.add(event.z);

        survey.accelerometerTimestamps.add(DateTime.now());
      });
    }));
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        survey.gyroscopeValues.add(event.x);
        survey.gyroscopeValues.add(event.y);
        survey.gyroscopeValues.add(event.z);
        survey.gyroscopeTimestamps.add(DateTime.now());
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        survey.userAccelerometerValues.add(event.x);
        survey.userAccelerometerValues.add(event.y);
        survey.userAccelerometerValues.add(event.z);
        survey.userAccelerometerTimestamps.add(DateTime.now());
      });
    }));

    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
//      if (filePath != null) showInSnackBar('Saving video to $filePath');
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
      survey.video_file = filePath;
      controller.flash(true);

      survey.startTimeOfRecording = DateTime.now();

      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void onStopRecording({bool was_cancelled = false}) {
    for (var stream in _streamSubscriptions) {
      stream.cancel();
    }
    _streamSubscriptions.clear();

    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
//      showInSnackBar('Video recorded to: $videoPath');

//      UserDataContainer.of(context).data.last_video = videoPath;
      print("Stopped");

      controller.flash(false);
      init_process = false;
      _sub_cd?.cancel();

      if (was_cancelled == false) {
        Navigator.of(context).pushNamed(
          '/gtpage',
//          arguments: survey,
        );
      } else {
        survey.startTimeOfRecording = null;
        survey.clearSensorData();
      }
    });
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

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(survey.video_file));
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

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
}
