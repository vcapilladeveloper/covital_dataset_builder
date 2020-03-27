import 'package:flutter/material.dart';
import 'user_data_container.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/scheduler.dart';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GroundTruth extends StatefulWidget {
  @override
  _GroundTruthState createState() => new _GroundTruthState();
}

class _GroundTruthState extends State<GroundTruth> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  String video_file;

  double o2_gt;
  double hr_gt;

  bool init_app = false;
  bool playing = false;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      runInitTasks();
    });
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @protected
  Future<void> runInitTasks() async {
    video_file = ModalRoute.of(context).settings.arguments;

    _controller = VideoPlayerController.file(File(video_file))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
    );

    init_app = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Widget body_widgets;
    if (init_app == true) {
      body_widgets = all();
    } else {
      body_widgets = Container();
    }

    print("Video: " + video_file.toString());

//    var bright = theme.brightness;
    String icon = 'assets/images/logo_dark.png';

    return Scaffold(
      appBar: AppBar(
        title: Text("CoVital - Data collection"),
      ),
      body: body_widgets,
      floatingActionButton: init_app
          ? FloatingActionButton(
              onPressed: () {
                if (o2_gt == null || hr_gt == null) {
                  print("need gt data");
                  Fluttertoast.showToast(
                      msg:
                          "please input data ground truth data for SpO2 and HR",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
//                timeInSecForIosWeb: 1,
                      backgroundColor: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (o2_gt > 100 || o2_gt < 0 || hr_gt < 0) {
                  print("need gt data");
                  Fluttertoast.showToast(
                      msg:
                          "please input valid data ground truth data for SpO2 and HR",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
//                timeInSecForIosWeb: 1,
                      backgroundColor: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  send_data();
                }
              },
              child: Icon(
                Icons.send,
              ),
            )
          : null,
    );
  }

  Widget all() {
    return ListView(
      children: <Widget>[
        Chewie(
          controller: _chewieController,
        ),

        Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("GT SpO2 = " + o2_gt.toString()),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.input),
                            labelText: "SpO2 (%)"
                            //                  labelText: 'Frequency of capture (s)'
                            ),
                        onChanged: (String s) {
                          print("Submitted: " + s);
                          setState(() {
                            setState(() {
                              o2_gt = double.parse(s);
                            });
                          });
                        },
                        onSubmitted: (String s) {
                          print("Submitted: " + s);
                          setState(() {
                            setState(() {
                              o2_gt = double.parse(s);
                            });
                          });
                        },
                      ),
                    ],
                  )),
            )),

        Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("GT HR = " + hr_gt.toString()),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.input),
                            labelText: "HR (bpm)"
                            //                  labelText: 'Frequency of capture (s)'
                            ),
                        onChanged: (String s) {
                          print("Submitted: " + s);
                          setState(() {
                            setState(() {
                              hr_gt = double.parse(s);
                            });
                          });
                        },
                        onSubmitted: (String s) {
                          print("Submitted: " + s);
                          setState(() {
                            setState(() {
                              hr_gt = double.parse(s);
                            });
                          });
                        },
                      ),
                    ],
                  )),
            )),

//        _controller.value.initialized
//              ? AspectRatio(
//            aspectRatio: _controller.value.aspectRatio,
//            child: VideoPlayer(_controller),
//          )
//              : Container(),
      ],
    );
  }

  void send_data() {
    print("Data sent");
  }
}
