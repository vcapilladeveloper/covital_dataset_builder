import 'package:flutter/material.dart';
import 'user_data_container.dart';
import 'survey_lib/survey.dart';
import 'upload_button.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class ThankYouPage extends StatefulWidget {
  @override
  _ThankYouPageState createState() => new _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {

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
        title: Text("Thank you"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child:Container()),
          Image.asset("assets/checkmark.png"),
          Center(child: Text("Success!", style: TextStyle(fontSize: 30))),

          Center(child: Text("Your data has been submitted", style: TextStyle(fontSize: 20))),
          Expanded(child:Container()),
          nextPageButton()
        ],
      )
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
    return SafeArea(
      child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: RaisedButton(
                    elevation: 0,
                    child: Text(
                      "Start a new measurement",
                      style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.title.color),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      survey.clear();
                      Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false);
                    },
                  ))
            ],
          )),
    );
  }
}