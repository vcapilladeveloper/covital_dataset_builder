import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/scheduler.dart';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'dart:async';

import 'color_picker.dart';

import 'user_data_container.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'upload_button.dart';

import 'survey_lib/survey.dart';

class PatientInformationPage extends StatefulWidget {
  @override
  _PatientInformationPageState createState() =>
      new _PatientInformationPageState();
}

class _PatientInformationPageState extends State<PatientInformationPage> {
  Survey survey;

  Color _selected_color = null;
  bool get_skin_color = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
//    _controller?.dispose();
//    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    survey = UserDataContainer.of(context).data.current_survey;
    final ThemeData theme = Theme.of(context);

//    print("Video: " + survey.video_file.toString());

//    var bright = theme.brightness;
    String icon = 'assets/images/logo_dark.png';

    return Scaffold(
      appBar: AppBar(
        title: Text("3 of 5: Patient information"),
      ),
      body: ListView(children: userDataCard()),
//      floatingActionButton: init_app
//          ? FloatingActionButton(
//              onPressed: onPressedSendButton,
//              child: Icon(
//                Icons.send,
//              ),
//            )
//          : null,
      bottomNavigationBar: nextPageButton(),
    );
  }

//  Widget all() {
//    return ListView(
//      children: <Widget>[
////        deviceInfo(),
//
//
//
////        spo2DeviceInfo(),
//
//
////        GTMeasurements(),
//
//        UserDataCard(),
//
////        SPO2DeviceCard(),
//
////        init_app
////            ? UploadButton(
////          survey: survey,
////        )
////            : Container(),
//
////        _controller.value.initialized
////              ? AspectRatio(
////            aspectRatio: _controller.value.aspectRatio,
////            child: VideoPlayer(_controller),
////          )
////              : Container(),
//      ],
//    );
//  }

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

//  Widget GTMeasurements() {
//    return Container(
//      child: Column(
//        children: <Widget>[
//          ListTile(
//            title: Text("Measure from finger pulse oximeter"),
//          ),
//          Padding(
//              padding: EdgeInsets.only(left: 20, right: 20),
//              child: TextField(
//                keyboardType: TextInputType.number,
//                decoration: InputDecoration(
//                    border: UnderlineInputBorder(),
////                        prefixIcon: Icon(Icons.input),
//                    labelText: "SpO2 (%)"
//                    //                  labelText: 'Frequency of capture (s)'
//                    ),
//                onChanged: (String s) {
//                  print("Submitted: " + s);
//                  setState(() {
//                    setState(() {
//                      survey.o2gt = double.parse(s);
//                    });
//                  });
//                },
//                onSubmitted: (String s) {
//                  print("Submitted: " + s);
//                  setState(() {
//                    setState(() {
//                      survey.o2gt = double.parse(s);
//                    });
//                  });
//                },
//              )),
//          Padding(
//              padding: EdgeInsets.only(left: 20, right: 20),
//              child: TextField(
//                keyboardType: TextInputType.number,
//                decoration: InputDecoration(
//                    border: UnderlineInputBorder(),
////                        prefixIcon: Icon(Icons.input),
//                    labelText: "HR (bpm)"
//                    //                  labelText: 'Frequency of capture (s)'
//                    ),
//                onChanged: (String s) {
//                  print("Submitted: " + s);
//                  setState(() {
//                    setState(() {
//                      survey.hrgt = double.parse(s);
//                    });
//                  });
//                },
//                onSubmitted: (String s) {
//                  print("Submitted: " + s);
//                  setState(() {
//                    setState(() {
//                      survey.hrgt = double.parse(s);
//                    });
//                  });
//                },
//              )),
//        ],
//      ),
//    );
//  }

  List<Widget> userDataCard() {
    return [
      Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text("Patient information"),
//            subtitle: Text("Sex"),
          ),

          Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Sex",
                style: TextStyle(color: Colors.black54),
              )),
//          Divider(),

//          ListTile(
//            title: Text("Sex"),
//          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                  width: 110,
                  child: RaisedButton(
                    child: new Text('Male'),
                    textColor: Colors.white,
//                    shape: new RoundedRectangleBorder(
//                      borderRadius: new BorderRadius.circular(30.0),
//                    ),
                    color: survey.sex == Sex.male
                        ? Theme.of(context).accentColor
                        : Colors.grey,
                    onPressed: () => setState(() => survey.sex = Sex.male),
                  )),
              SizedBox(
                  width: 110,
                  child: RaisedButton(
                    child: new Text('Female'),
                    textColor: Colors.white,
//                    shape: new RoundedRectangleBorder(
//                      borderRadius: new BorderRadius.circular(30.0),
//                    ),
                    color: survey.sex == Sex.female
                        ? Theme.of(context).accentColor
                        : Colors.grey,
                    onPressed: () => setState(() => survey.sex = Sex.female),
                  )),
              SizedBox(
                  width: 110,
                  child: RaisedButton(
                    child: new Text('Unknown'),
                    textColor: Colors.white,
//                    shape: new RoundedRectangleBorder(
//                      borderRadius: new BorderRadius.circular(30.0),
//                    ),
                    color: survey.sex == Sex.undefined
                        ? Theme.of(context).accentColor
                        : Colors.grey,
                    onPressed: () => setState(() => survey.sex = Sex.undefined),
                  ))
            ],
          ),

//          Padding(
//              padding: EdgeInsets.only(left: 15),
//              child: Text(
//                "Health",
//                style: TextStyle(color: Colors.black54),
//              )),
//
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              SizedBox(
//                  width: 110,
//                  child: RaisedButton(
//                    child: new Text('Healthy'),
//                    textColor: Colors.white,
////                    shape: new RoundedRectangleBorder(
////                      borderRadius: new BorderRadius.circular(30.0),
////                    ),
//                    color: survey.health == Health.healthy
//                        ? Theme.of(context).accentColor
//                        : Colors.grey,
//                    onPressed: () =>
//                        setState(() => survey.health = Health.healthy),
//                  )),
//              SizedBox(
//                  width: 110,
//                  child: RaisedButton(
//                    child: new Text('Sick'),
//                    textColor: Colors.white,
////                    shape: new RoundedRectangleBorder(
////                      borderRadius: new BorderRadius.circular(30.0),
////                    ),
//                    color: survey.health == Health.sick
//                        ? Theme.of(context).accentColor
//                        : Colors.grey,
//                    onPressed: () =>
//                        setState(() => survey.health = Health.sick),
//                  )),
//              SizedBox(
//                  width: 110,
//                  child: RaisedButton(
//                    child: new Text('Unknown'),
//                    textColor: Colors.white,
////                    shape: new RoundedRectangleBorder(
////                      borderRadius: new BorderRadius.circular(30.0),
////                    ),
//                    color: survey.health == Health.undefined
//                        ? Theme.of(context).accentColor
//                        : Colors.grey,
//                    onPressed: () =>
//                        setState(() => survey.health = Health.undefined),
//                  ))
//            ],
//          ),

          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Theme(
                  data: Theme.of(context).copyWith(
                      hintColor: survey.age == null
                          ? Theme.of(context).accentColor
                          : Theme.of(context).hintColor), // set color here
                  child: TextFormField(
                    initialValue:
                        survey.age != null ? survey.age.toString() : "",
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(),
//                        prefixIcon: Icon(Icons.input),
                        labelText: "Age (years)"
                        //                  labelText: 'Frequency of capture (s)'
                        ),
                    onChanged: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          if(s.isNotEmpty) {
                            survey.age = int.parse(s);
                          }
                          else{
                            survey.age = null;
                          }
                        });
                      });
                    },
                  ))),
          Divider(),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Theme(
                  data: Theme.of(context).copyWith(
                      hintColor: survey.weight == null
                          ? Theme.of(context).accentColor
                          : Theme.of(context).hintColor), // set color here
                  child: TextFormField(
                    initialValue:
                        survey.weight != null ? survey.weight.toString() : "",
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(),
//                        prefixIcon: Icon(Icons.input),
                        labelText: "Weight (kg)"
                        //                  labelText: 'Frequency of capture (s)'
                        ),
                    onChanged: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          if(s.isNotEmpty) {
                            survey.weight = double.parse(s);
                          }
                          else{
                            survey.weight = null;
                          }
                        });
                      });
                    },
                  ))),
          Divider(),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Theme(
                  data: Theme.of(context).copyWith(
                      hintColor: survey.height == null
                          ? Theme.of(context).accentColor
                          : Theme.of(context).hintColor), // set color here
                  child: TextFormField(
                    initialValue:
                    survey.height != null ? survey.height.toString() : "",
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(),
//                        prefixIcon: Icon(Icons.input),
                        labelText: "Height (cm)"
                      //                  labelText: 'Frequency of capture (s)'
                    ),
                    onChanged: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          if(s.isNotEmpty) {
                            survey.height = double.parse(s);
                          }
                          else{
                            survey.height = null;
                          }
                        });
                      });
                    },
                  ))),
          Divider(),
//                  Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      children: <Widget>[
//                        SizedBox (width: 50, child: Text("Sex")),
//                        sexDropDown(),
//                      ]),
//                  Divider(),
//          Row(
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
//              children: <Widget>[
//                SizedBox(width: 50, child: Text("Health")),
//                healthDropDown(),
//              ]),
//          Divider(),

          ListTile(title: Text("Skin tone (approximate)")),

          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
//                CircleColor(circleSize: 35, color: Colors.transparent, onColorChoose: (){
//                  print("Chrosen");
//                  setState(() {
//                    survey.skinColor = null;
//                  });
//                },
//                isSelected: survey.skinColor == null ? true : false,
//                  iconSelected: Icons.check,
//                ),

//            Checkbox(
//              value: get_skin_color,
//              onChanged: (bool v){
//                print("p" + v.toString());
//                get_skin_color = v;
//                if(v == false){
//                  setState(() {
//                    survey.skinColor = null;
//                  });
//                }
//                if(v == true){
//                  setState(() {
////                    survey.skinColor = _selected_color.value;
//                  });
//                }
//
//              },
//            ),
                SizedBox(
                  height: 100,
                  child: get_skin_color
                      ? colorPicker(UserDataContainer.of(context).data.colors)
                      : Container(),
                )
              ]),

//          Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
////                        Text("Ethnicity"),
////                        ethnicityDropDown(),
////                      ]),
//                OutlineButton(
//                  onPressed: () {
//                    var colors = UserDataContainer.of(context).data.colors;
//                    _openColorPicker(context, colors);
//                  },
//                  child: const Text('Select skin color'),
//                ),
//                survey.skinColor == null
//                    ? Text("None")
//                    : CircleColor(
//                        color: Color(survey.skinColor),
//                        circleSize: 35,
//                      ),
//              ]),

//        nextPageButton()
        ],
      )),
    ];
  }

  Widget colorPicker(List<ColorSwatch> colors) {
    return CovitalColorPicker(
//      circleSize: 25,
      circleSize: 40,
      allowShades: false,
      onMainColorChange: (Color color) {
        // Handle color changes
        setState(() {
          survey.skinColor = color.value;
          _selected_color = color;
          print("updated skin color: " + color.value.toString());
        });
      },
      iconSelected:
          survey.skinColor != null ? Icons.check : Icons.tab_unselected,
      selectedColor: _selected_color,
      colors: colors,
    );
  }
//
//  void _openColorPicker(BuildContext context, List<ColorSwatch> colors) async {
//    _openDialog(context, "Skin Color", colorPicker(colors));
//  }
//
//  void _openDialog(BuildContext context, String title, Widget content) {
//    showDialog(
//      context: context,
//      builder: (_) {
//        return AlertDialog(
//          contentPadding: const EdgeInsets.all(6.0),
//          title: Text(title),
//          content: content,
//          actions: [
//            FlatButton(
//              child: Text('CANCEL'),
//              onPressed: Navigator.of(context).pop,
//            ),
//            FlatButton(
//              child: Text('SUBMIT'),
//              onPressed: () {
//                Navigator.of(context).pop();
//
////                setState(() => _mainColor = _tempMainColor);
////                setState(() => _shadeColor = _tempShadeColor);
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

//  List<Widget> createRadioListSex() {
//    List<Widget> widgets = List<Widget>();
//    for (Sex sex in Sex.values) {
//      if (sex != Sex.undefined) {
//        widgets.add(
//          SizedBox(
//              width: 200,
//              child: RadioListTile(
//                value: sex,
//                groupValue: survey.sex,
//                title: Text(sex.toString().split(".").last),
////          subtitle: Text(programming.developer),
//                onChanged: (sex_change) {
//                  setState(() {
//                    survey.sex = sex_change;
//                  });
//                  print("Current ${sex_change}");
//                },
//                selected: survey.sex == sex,
//                activeColor: Colors.green,
//              )),
//        );
//      }
//    }
//    return widgets;
//  }
//
//  Widget sexDropDown() {
//    return Column(
//      children: createRadioListSex(),
//    );
////    return DropdownButton<Sex>(
////        value: survey.sex,
////        onChanged: (Sex newValue) {
////          setState(() {
////            survey.sex = newValue;
////          });
////        },
////        items: Sex.values.map((Sex sex) {
////          return DropdownMenuItem<Sex>(value: sex, child: Text(sex.toString()));
////        }).toList());
//  }
//
////  Widget ethnicityDropDown() {
////    return DropdownButton<Ethnicity>(
////        value: survey.ethnicity,
////        onChanged: (Ethnicity newValue) {
////          setState(() {
////            survey.ethnicity = newValue;
////          });
////        },
////        items: Ethnicity.values.map((Ethnicity ethni) {
////          return DropdownMenuItem<Ethnicity>(
////              value: ethni, child: Text(ethni.toString()));
////        }).toList());
////  }
//
//  List<Widget> createRadioListHealth() {
//    List<Widget> widgets = List<Widget>();
//    for (Health health in Health.values) {
//      if (health != Health.undefined) {
//        widgets.add(
//          SizedBox(
//              width: 200,
//              child: RadioListTile(
//                value: health,
//                groupValue: survey.health,
//                title: Text(health.toString().split(".").last),
////
////          subtitle: Text(programming.developer),
//                onChanged: (health_change) {
//                  setState(() {
//                    survey.health = health_change;
//                  });
//                  print("Current ${health_change}");
//                },
//                selected: survey.health == health,
//                activeColor: Colors.green,
//              )),
//        );
//      }
//    }
//    return widgets;
//  }
//
//  Widget healthDropDown() {
//    return Column(
//      children: createRadioListHealth(),
//    );

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
//  }
//
//  Widget SPO2DeviceCard() {
//    var settings = UserDataContainer.of(context).data.commercial_device;
//    return Padding(
//        padding: EdgeInsets.all(10),
//        child: Card(
//          color: Colors.white54,
//          child: Padding(
//              padding: EdgeInsets.all(10),
//              child: Column(children: <Widget>[
//                ListTile(
//                  title: Text("SpO2 Device (optional)",
//                      style: TextStyle(fontWeight: FontWeight.bold)),
//                ),
//                TextFormField(
////                  keyboardType: TextInputType.number,
//                  initialValue: settings.brand == null ? "" : settings.brand,
//                  decoration: InputDecoration(
//                      border: OutlineInputBorder(),
//                      prefixIcon: Icon(Icons.input),
//                      labelText: "Brand"
//                      //                  labelText: 'Frequency of capture (s)'
//                      ),
//                  onChanged: (String s) {
//                    print("Submitted: " + s);
//                    setState(() {
//                      setState(() {
//                        settings.brand = s;
//                        settings.save();
//                      });
//                    });
//                  },
//                ),
//                Divider(),
//                TextFormField(
//                  initialValue: settings.model == null ? "" : settings.model,
////                    keyboardType: TextInputType.number,
//                  decoration: InputDecoration(
//                      border: OutlineInputBorder(),
//                      prefixIcon: Icon(Icons.input),
//                      labelText: "Model"
//                      //                  labelText: 'Frequency of capture (s)'
//                      ),
//                  onChanged: (String s) {
//                    print("Submitted: " + s);
//                    setState(() {
//                      setState(() {
//                        settings.model = s;
//                        settings.save();
//                      });
//                    });
//                  },
//                ),
//              ])),
//        ));
//  }

  Widget nextPageButton() {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Expanded(
                child: RaisedButton(
              child: Text(
                "Next: Patient History",
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.title.color),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.of(context).pushNamed("/medical_history");
              },
            ))
          ],
        ));
  }
}
