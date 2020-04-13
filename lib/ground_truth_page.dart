import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/scheduler.dart';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'dart:async';

import 'user_data_container.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'upload_button.dart';

import 'survey_lib/survey.dart';

class GroundTruthPage extends StatefulWidget {
  @override
  _GroundTruthPageState createState() => new _GroundTruthPageState();
}

class _GroundTruthPageState extends State<GroundTruthPage> {
  Survey survey;

//  double o2_gt;
//  double hr_gt;

  bool init_app = false;
  bool playing = false;

  //to ensure image is uploading from the native android
//  bool isFileUploading = false;

//  String poolId;
//  String awsFolderPath;
//  String bucketName;

  //To hold image paths after uploading to s3 for adding to db
//  File selectedFile;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      runInitTasks();
    });
  }

//  void readEnv() async {
//    final str = await rootBundle.loadString(".env");
//    if (str.isNotEmpty) {
//      final decoded = jsonDecode(str);
//      poolId = decoded["poolId"];
//      awsFolderPath = decoded["awsFolderPath"];
//      bucketName = decoded["bucketName"];
//    }
//  }

//  @override
//  void dispose() {
//    // Ensure disposing of the VideoPlayerController to free up resources.
//    _controller?.dispose();
//    _chewieController?.dispose();
//    super.dispose();
//  }

  @protected
  Future<void> runInitTasks() async {
//    await readEnv();

    survey = UserDataContainer.of(context).data.current_survey;

    survey.spo2Device = UserDataContainer.of(context).data.commercial_device;

    assert(UserDataContainer.of(context).data.commercial_device != null);
    assert(survey.spo2Device != null);

//    _controller = VideoPlayerController.file(File(survey.video_file))
//      ..initialize().then((_) {
//        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//        setState(() {});
//      });
//
//    _chewieController = ChewieController(
//      videoPlayerController: _controller,
//      aspectRatio: 7/2,
//
//
//      autoPlay: true,
//      looping: false,
//    );

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

//    print("Video: " + survey.video_file.toString());

//    var bright = theme.brightness;
    String icon = 'assets/images/logo_dark.png';

    return Scaffold(
      appBar: AppBar(
        title: Text("2 of 5: Measure using\noximeter"),
      ),
      body: body_widgets,
//      floatingActionButton: init_app
//          ? FloatingActionButton(
//              onPressed: onPressedSendButton,
//              child: Icon(
//                Icons.send,
//              ),
//            )
//          : null,
      bottomNavigationBar: SafeArea(child: nextPageButton()),
    );
  }

  Widget all() {
    return ListView(
      children: <Widget>[
//        deviceInfo(),

//        spo2DeviceInfo(),

        completeCheck(),

        Divider(),

        GTMeasurements(),

//        UserDataCard(),

        Divider(),

        SPO2DeviceCard(),

//      Divider(),

//      nextPageButton(),

//        init_app
//            ? UploadButton(
//          survey: survey,
//        )
//            : Container(),

//        _controller.value.initialized
//              ? AspectRatio(
//            aspectRatio: _controller.value.aspectRatio,
//            child: VideoPlayer(_controller),
//          )
//              : Container(),
      ],
    );
  }

  Widget completeCheck() {
    return Container(
        child: Column(
      children: <Widget>[
        ListTile(
          title: Text("CoVital measurements complete",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
//          Chewie(
//            controller: _chewieController,
//          ),
      ],
    ));
  }

  Widget deviceInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text("Phone: " + survey.phoneBrand + " " + survey.phoneModel),
//        Text(survey.phone_reference),
//        Text(survey.deviceData['model'])
      ],
    );
  }

//  Widget spo2DeviceInfo() {
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.start,
//      children: <Widget>[
//        Text("Spo2 device: " +
//            survey.commercialDevice.reference_number.toString() + " " +
//            survey.commercialDevice.brand.toString()),
//      ],
//    );
//  }

  Widget nextPageButton() {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Expanded(
                child: RaisedButton(
                  elevation: 0,
              child: Text(
                "Next: Patient Information",
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.title.color),
              ),
              color: Theme.of(context).accentColor,
              onPressed: (survey.spo2 == null || survey.hr == null) ? null : () {
//                if (survey.o2gt == null || survey.hrgt == null) {
//                  print("need gt data");
//                  Fluttertoast.showToast(
//                      msg:
//                          "please input data ground truth data for SpO2 and HR",
//                      toastLength: Toast.LENGTH_SHORT,
//                      gravity: ToastGravity.CENTER,
////                timeInSecForIosWeb: 1,
//                      backgroundColor: Theme.of(context).accentColor,
//                      textColor: Colors.white,
//                      fontSize: 16.0);
//                } else
                  if (survey.spo2 > 100 ||
                    survey.spo2 < 0 ||
                    survey.hr < 0) {
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
                  Navigator.of(context).pushNamed("/patient_information");
                }
              },
            ))
          ],
        ));
  }

  Widget GTMeasurements() {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Enter data from finger pulse oximeter"),
          ),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Theme(
                  data: Theme.of(context).copyWith(
                      hintColor: survey.spo2 == null
                          ? Theme.of(context).accentColor
                          : Theme.of(context).hintColor), // set color here
                  child: TextFormField(
                    initialValue:
                        survey.spo2 != null ? survey.spo2.toString() : "",
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
//                        enabledBorder: OutlineInputBorder(),
                        border: UnderlineInputBorder(),
//                        prefixIcon: Icon(Icons.input),
                        labelText: "SpO2 (%)"
                        //                  labelText: 'Frequency of capture (s)'
                        ),
                    onChanged: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          if (s.isNotEmpty) {
                            survey.spo2 = double.parse(s);
                          } else {
                            survey.spo2 = null;
                          }
                        });
                      });
                    },
                  ))),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Theme(
                  data: Theme.of(context).copyWith(
                      hintColor: survey.hr == null
                          ? Theme.of(context).accentColor
                          : Theme.of(context).hintColor), // set color here
                  child: TextFormField(
                    initialValue:
                        survey.hr != null ? survey.hr.toString() : "",
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(),
//                        prefixIcon: Icon(Icons.input),
                        labelText: "Heart rate (BPM)"
                        //                  labelText: 'Frequency of capture (s)'
                        ),
                    onChanged: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          if (s.isNotEmpty) {
                            survey.hr = double.parse(s);
                          } else {
                            survey.hr = null;
                          }
                        });
                      });
                    },
//                    onSubmitted: (String s) {
//                      print("Submitted: " + s);
//                      setState(() {
//                        setState(() {
//                          survey.hrgt = double.parse(s);
//                        });
//                      });
//                    },
                  ))),
        ],
      ),
    );
  }

  Widget SPO2DeviceCard() {
    var settings = UserDataContainer.of(context).data.commercial_device;
    return Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Text("About your finger pulse oximeter (optional)"),
      ),
      Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Theme(
              data: Theme.of(context).copyWith(
                  hintColor: settings.brand == null
                      ? Theme.of(context).accentColor
                      : Theme.of(context).hintColor), // set color here
              child: TextFormField(
//                  keyboardType: TextInputType.number,
                initialValue: settings.brand == null ? "" : settings.brand,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(),
//                          prefixIcon: Icon(Icons.input),
                    labelText: "Oximeter brand (optional)"
                    //                  labelText: 'Frequency of capture (s)'
                    ),
                onChanged: (String s) {
                  print("Submitted: " + s);
                  setState(() {
                    setState(() {
                      if (s.isNotEmpty) {
                        settings.brand = s;
                      } else {
                        settings.brand = null;
                      }
                      settings.save();
                    });
                  });
                },
              ))),
      SizedBox(
        height: 10,
      ),
//                    Divider(),
      Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Theme(
              data: Theme.of(context).copyWith(
                  hintColor: settings.model == null
                      ? Theme.of(context).accentColor
                      : Theme.of(context).hintColor), // set color here
              child: TextFormField(
                initialValue: settings.model == null ? "" : settings.model,
//                    keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(),
//                          prefixIcon: Icon(Icons.input),
                    labelText: "Oximeter model (optional)"
                    //                  labelText: 'Frequency of capture (s)'
                    ),
                onChanged: (String s) {
                  print("Submitted: " + s);
                  setState(() {
                    setState(() {
                      if (s.isNotEmpty) {
                        settings.model = s;
                      } else {
                        settings.model = null;
                      }
                      settings.save();
                    });
                  });
                },
              ))),
    ]));
  }
}
