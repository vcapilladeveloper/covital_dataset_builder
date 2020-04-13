import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'user_data_container.dart';
import 'survey_lib/survey.dart';
import 'upload_button.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/scheduler.dart';
import 'dart:io';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => new _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  VideoPlayerController _controller;
  ChewieController _chewieController;


  Survey survey;
  double progress_value = 0;
  bool uploading = false;

  bool init_app = false;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      runInitTasks();
    });
  }

  @protected
  Future<void> runInitTasks() async {
//    await readEnv();

    survey = UserDataContainer.of(context).data.current_survey;



    _controller = VideoPlayerController.file(File(survey.video_file))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 2/1,


      autoPlay: true,
      looping: false,
    );

    init_app = true;
    setState(() {});
  }


  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    survey = UserDataContainer
        .of(context)
        .data
        .current_survey;


    return Scaffold(
      appBar: AppBar(
        title: Text(uploading ? "Submitting..." : "5 of 5: Review and submit"),
      ),
      body: init_app ? all() : CircularProgressIndicator(),
//      floatingActionButton: init_app
//          ? FloatingActionButton(
//              onPressed: onPressedSendButton,
//              child: Icon(
//                Icons.send,
//              ),
//            )
//          : null,
      bottomNavigationBar: SafeArea(child: UploadButton(survey: survey, updateProgress: updateProgress, isUploading: uploadUpdate,)),
    );
  }

  void uploadUpdate(bool upload){
    setState(() {
      uploading = upload;
      progress_value = null;
    });
  }

  void updateProgress(double progress_value_in){
    setState(() {
      progress_value = progress_value_in;
    });
  }


  Widget all(){
    return Column(
      children: <Widget>[
//
//        Chewie(
//          controller: _chewieController,
//        ),

        pulseOxReview(),

        Divider(),

        patientDataReview(),

        Divider(),

    Expanded(child:Container()),
    LinearProgressIndicator(
        value: progress_value,
      )

//        Expanded(child:Container()),

//        nextPageButton()
      ],
    );
  }


  Widget pulseOxReview(){


    Widget data =  Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Container(child:Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Spo2"),
            Text(survey.spo2.toString() + "%", style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),

        SizedBox(height: 10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Heart rate"),
            Text(survey.hr.toString() + " BPM", style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),

        SizedBox(height: 10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Oximeter brand"),
            Text(survey.spo2Device.brand != null ? survey.spo2Device.brand.toString() : "undefined", style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),

        SizedBox(height: 10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Oximeter model"),
            Text(survey.spo2Device.model != null ? survey.spo2Device.model.toString() : "undefined", style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),

      ],
    )));

    List<Widget> ret = [
        ListTile(title: Text("Finger Pulse Oximeter Measurements")),

//      Divider(),
      data




    ];

    return Container(child: Column( children: ret));
  }


  Widget patientDataReview(){


    Widget data =  Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Container(child:Column(
          children: <Widget>[

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Expanded(
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text("Sex"),
                          SizedBox(height: 10,),
                          Text("Height"),
//                          SizedBox(height: 10,),
//                          Text("Respiratory Symptoms"),
                        ])),
                Expanded(
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(survey.sex.toString().split(".").last, style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text(survey.height != null ? survey.height.toString() + " cm" : "undefined", style: TextStyle(fontWeight: FontWeight.bold),),
//                          SizedBox(height: 10,),
//                          Text(survey.health.toString().split(".").last, style: TextStyle(fontWeight: FontWeight.bold),),


                        ])),

                VerticalDivider(),
                Expanded(
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          Text("Age"),
                          SizedBox(height: 10,),
                          Text("Weight"),
                        ])),
                Expanded(
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          Text(survey.age != null ? survey.age.toString() + " years" : "undefined", style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text(survey.weight != null ? survey.weight.toString() + " kg": "undefined", style: TextStyle(fontWeight: FontWeight.bold),)

                        ])),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    Text("Sex"),
//                    Text(survey.sex.toString().split(".").last, style: TextStyle(fontWeight: FontWeight.bold),),
//]),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    Text("Health"),
//                    Text(survey.health.toString().split(".").last, style: TextStyle(fontWeight: FontWeight.bold),)
//                  ],
//                ),

              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Text("Respiratory Symptoms "),
                Text(survey.respiratorySymptoms.toString().split(".").last, style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
//                Expanded(child:Column(
//              children: <Widget>[
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text("Age"),
//                    Text(survey.age.toString() + " years", style: TextStyle(fontWeight: FontWeight.bold),),
//                  ]),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text("Height"),
//                    Text(survey.height.toString() + " cm", style: TextStyle(fontWeight: FontWeight.bold),)
//                  ],
//                ),
//
//              ],
//                )),
//
//            ],),


            SizedBox(height: 20,),

//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Text("Weight"),
//                Text(survey.weight.toString() + " kg", style: TextStyle(fontWeight: FontWeight.bold),),
//
//                Text("Height"),
//                Text(survey.height.toString() + " cm", style: TextStyle(fontWeight: FontWeight.bold),)
//              ],
//            ),

//            SizedBox(height: 10,),



            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[


                SizedBox(height: 10,),

            Text("Skin tone: "),

            survey.skinColor == null
                    ? Text("None")
                    : CircleColor(
                        color: Color(survey.skinColor),
                        circleSize: 35,
              elevation: 0,
                      ),
              ],
            ),

          ],
        )));

    List<Widget> ret = [
      ListTile(title: Text("Patient Information")),

//      Divider(),

data,



    ];

    return Container(child: Column( children: ret));
  }

//  Widget nextPageButton(){
//    return UploadButton();
//  }

}


