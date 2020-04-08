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

import 'upload_button.dart';

import 'survey_lib/survey.dart';


class GroundTruth extends StatefulWidget {
  @override
  _GroundTruthState createState() => new _GroundTruthState();
}

class _GroundTruthState extends State<GroundTruth> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
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

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @protected
  Future<void> runInitTasks() async {
//    await readEnv();

    survey = ModalRoute
        .of(context)
        .settings
        .arguments;

    survey.spo2Device = UserDataContainer
        .of(context)
        .data
        .commercial_device;

    assert(UserDataContainer
        .of(context)
        .data
        .commercial_device != null);
    assert(survey.spo2Device != null);

    _controller = VideoPlayerController.file(File(survey.video_file))
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

//    print("Video: " + survey.video_file.toString());

//    var bright = theme.brightness;
    String icon = 'assets/images/logo_dark.png';

    return Scaffold(
      appBar: AppBar(
        title: Text("CoVital - Data collection"),
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
    );
  }

  Widget all() {
    return ListView(
      children: <Widget>[
        deviceInfo(),

//        spo2DeviceInfo(),

        Chewie(
          controller: _chewieController,
        ),

        GTMeasurements(),

        UserDataCard(),

        SPO2DeviceCard(),

        init_app
            ? UploadButton(
          survey: survey,
        )
            : Container(),

//        _controller.value.initialized
//              ? AspectRatio(
//            aspectRatio: _controller.value.aspectRatio,
//            child: VideoPlayer(_controller),
//          )
//              : Container(),
      ],
    );
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

  Widget GTMeasurements() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Card(
            color: Colors.yellow,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("Ground truth measurements", style: TextStyle(fontWeight: FontWeight.bold)),
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
                          survey.o2gt = double.parse(s);
                        });
                      });
                    },
                    onSubmitted: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          survey.o2gt = double.parse(s);
                        });
                      });
                    },
                  ),
                  Divider(),
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
                          survey.hrgt = double.parse(s);
                        });
                      });
                    },
                    onSubmitted: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          survey.hrgt = double.parse(s);
                        });
                      });
                    },
                  ),
                ],
              )),
        ));
  }

  Widget UserDataCard() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          color: Theme.of(context).primaryColorLight,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("User Data", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.input),
                        labelText: "Age (years)"
                      //                  labelText: 'Frequency of capture (s)'
                    ),
                    onChanged: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          survey.age = int.parse(s);
                        });
                      });
                    },
                    onSubmitted: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          survey.age = int.parse(s);
                        });
                      });
                    },
                  ),
                  Divider(),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.input),
                        labelText: "Weight (kg)"
                      //                  labelText: 'Frequency of capture (s)'
                    ),
                    onChanged: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          survey.weight = double.parse(s);
                        });
                      });
                    },
                    onSubmitted: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          survey.weight = double.parse(s);
                        });
                      });
                    },
                  ),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox (width: 50, child: Text("Sex")),
                        sexDropDown(),
                      ]),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox (width: 50, child: Text("Health")),
                        healthDropDown(),
                      ]),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
//                        Text("Ethnicity"),
//                        ethnicityDropDown(),
//                      ]),
                  OutlineButton(
                    onPressed: (){
                      var colors = UserDataContainer.of(context).data.colors;
                      _openColorPicker(context, colors);

                    },
                    child: const Text('Select skin color'),
                  ),
                        survey.skinColor == null ? Text("None") : CircleColor(color: Color(survey.skinColor), circleSize: 35,),
                  ]),


                ],
              )),
        ));
  }

  void _openColorPicker(BuildContext context, List<ColorSwatch> colors) async {
    _openDialog(
      context,
      "Skin Color",
        MaterialColorPicker(
          allowShades: false,
          onMainColorChange: (Color color) {
            // Handle color changes
            setState(() {
              survey.skinColor = color.value;
              print("updated skin color: " + color.value.toString());
            });
          },
//          selectedColor: Colors.red,
          colors: colors,
        )
    );
  }

  void _openDialog(BuildContext context, String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();

//                setState(() => _mainColor = _tempMainColor);
//                setState(() => _shadeColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> createRadioListSex() {
    List<Widget> widgets = List<Widget>();
    for (Sex sex in Sex.values) {
      if(sex != Sex.undefined) {
        widgets.add(
          SizedBox(width: 200, child: RadioListTile(
            value: sex,
            groupValue: survey.sex,
            title: Text(sex
                .toString()
                .split(".")
                .last),
//          subtitle: Text(programming.developer),
            onChanged: (sex_change) {
              setState(() {
                survey.sex = sex_change;
              });
              print("Current ${sex_change}");
            },
            selected: survey.sex == sex,
            activeColor: Colors.green,
          )),
        );
      }
    }
    return widgets;
  }

  Widget sexDropDown() {
    return Column(
      children:
        createRadioListSex(),
    );
//    return DropdownButton<Sex>(
//        value: survey.sex,
//        onChanged: (Sex newValue) {
//          setState(() {
//            survey.sex = newValue;
//          });
//        },
//        items: Sex.values.map((Sex sex) {
//          return DropdownMenuItem<Sex>(value: sex, child: Text(sex.toString()));
//        }).toList());
  }

//  Widget ethnicityDropDown() {
//    return DropdownButton<Ethnicity>(
//        value: survey.ethnicity,
//        onChanged: (Ethnicity newValue) {
//          setState(() {
//            survey.ethnicity = newValue;
//          });
//        },
//        items: Ethnicity.values.map((Ethnicity ethni) {
//          return DropdownMenuItem<Ethnicity>(
//              value: ethni, child: Text(ethni.toString()));
//        }).toList());
//  }

  List<Widget> createRadioListHealth() {
    List<Widget> widgets = List<Widget>();
    for (Health health in Health.values) {
      if(health != Health.undefined) {
        widgets.add(
          SizedBox(width: 200, child: RadioListTile(
            value: health,
            groupValue: survey.health,
            title: Text(health
                .toString()
                .split(".")
                .last),
//
//          subtitle: Text(programming.developer),
            onChanged: (health_change) {
              setState(() {
                survey.health = health_change;
              });
              print("Current ${health_change}");
            },
            selected: survey.health == health,
            activeColor: Colors.green,
          )),
        );
      }
    }
    return widgets;
  }

  Widget healthDropDown() {
    return Column(
      children:
      createRadioListHealth(),
    );

//    return DropdownButton<Health>(
//        value: survey.health,
//        onChanged: (Health newValue) {
//          setState(() {
//            survey.health = newValue;
//          });
//        },
//        items: Health.values.map((Health health) {
//          return DropdownMenuItem<Health>(
//              value: health, child: Text(health.toString()));
//        }).toList());
  }


  Widget SPO2DeviceCard() {
    var settings = UserDataContainer.of(context).data.commercial_device;
    return Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          color: Colors.white54,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("SpO2 Device (optional)", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TextFormField(
//                  keyboardType: TextInputType.number,
                  initialValue: settings.brand == null ? "" : settings.brand,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.input),
                        labelText: "Brand"
                      //                  labelText: 'Frequency of capture (s)'
                    ),
                    onChanged: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          settings.brand = s;
                          settings.save();
                        });
                      });
                    },

                  ),
                  Divider(),
                  TextFormField(
                    initialValue: settings.model == null ? "" : settings.model,
//                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.input),
                        labelText: "Model"
                      //                  labelText: 'Frequency of capture (s)'
                    ),
                    onChanged: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          settings.model = s;
                          settings.save();
                        });
                      });
                    },

                  ),
                  ]
              )),
        ));
  }



}
