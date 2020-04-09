import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'user_data_container.dart';
import 'survey_lib/survey.dart';
import 'upload_button.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => new _StartPageState();
}

class _StartPageState extends State<StartPage> {

  Survey survey;


  @override
  void initState() {
    super.initState();
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
          title: Text("CoVital Calibration Tool"),
        ),
        body: Padding(padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child:Container()),
            Image.asset("assets/logo2_small.png"),
//            Center(child: Text("Success!", style: TextStyle(fontSize: 30))),

            Center(child: Text("Thank you for helping us create CoVital, an app to self-monitor oxygen saturation and heart rate.\n", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
            Center(child: Text("Instructions:\n• Measure the patient O2 and heart rate using this app.\n• Measure the patient O2 and heart using a pulse oximeter.\n• Provide patient information.\n• Submit.", style: TextStyle(fontSize: 20), textAlign: TextAlign.center)),
            Center(child: Text("\nWe will use your submission to calibrate CoVital for accurate readings.", style: TextStyle(fontSize: 20), textAlign: TextAlign.center)),
            Expanded(child:Container()),
            nextPageButton()
          ],
        ))
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

  Widget nextPageButton(){
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Expanded(
                child: RaisedButton(
                  child: Text(
                    "Start a new measurement",
                    style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    survey.clear();
                    Navigator.of(context).pushNamed("/home");
                  },
                ))
          ],
        ));
  }
}