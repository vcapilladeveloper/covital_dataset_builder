import 'package:flutter/material.dart';
import 'user_data_container.dart';
import 'survey_lib/survey.dart';

class MedicalHistoryPage extends StatefulWidget {
  @override
  _MedicalHistoryPageState createState() => new _MedicalHistoryPageState();
}

class _MedicalHistoryPageState extends State<MedicalHistoryPage> {
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

//  @protected
//  Future<void> runInitTasks() async {
////    await readEnv();
//
////    survey = ModalRoute
////        .of(context)
////        .settings
////        .arguments;
////
////    survey.spo2Device = UserDataContainer
////        .of(context)
////        .data
////        .commercial_device;
//
//    assert(UserDataContainer
//        .of(context)
//        .data
//        .commercial_device != null);
//    assert(survey.spo2Device != null);
//
//    _controller = VideoPlayerController.file(File(survey.video_file))
//      ..initialize().then((_) {
//        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//        setState(() {});
//      });
//
//    _chewieController = ChewieController(
//      videoPlayerController: _controller,
//      aspectRatio: 3 / 2,
//      autoPlay: true,
//      looping: true,
//    );
//
//    init_app = true;
//    setState(() {});
//  }

  @override
  Widget build(BuildContext context) {
    survey = UserDataContainer.of(context).data.current_survey;

    final ThemeData theme = Theme.of(context);

//    print("Video: " + survey.video_file.toString());

//    var bright = theme.brightness;
    String icon = 'assets/images/logo_dark.png';

    return Scaffold(
      appBar: AppBar(
        title: Text("4 of 5: Medical History and\nStatus"),
      ),
      body: respiratorySymptoms(),

      bottomNavigationBar: SafeArea(child: nextPageButton()),
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
//
//  Widget all() {
//    return ListView(
//      children: <Widget>[Text("TODO")],
//
//    );
//  }

  Widget respiratorySymptoms() {
    return
      ListView(
        children: createRadioListHealth(),
      );


//      Column(children: [
//      Padding(
//          padding: EdgeInsets.only(left: 15),
//          child: Text(
//            "Health",
//            style: TextStyle(color: Colors.black54),
//          )),
//      Row(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: <Widget>[
//          SizedBox(
//              width: 110,
//              child: RaisedButton(
//                child: new Text('Healthy'),
//                textColor: Colors.white,
////                    shape: new RoundedRectangleBorder(
////                      borderRadius: new BorderRadius.circular(30.0),
////                    ),
//                color: survey.health == Health.healthy
//                    ? Theme.of(context).accentColor
//                    : Colors.grey,
//                onPressed: () => setState(() => survey.health = Health.healthy),
//              )),
//          SizedBox(
//              width: 110,
//              child: RaisedButton(
//                child: new Text('Sick'),
//                textColor: Colors.white,
////                    shape: new RoundedRectangleBorder(
////                      borderRadius: new BorderRadius.circular(30.0),
////                    ),
//                color: survey.health == Health.sick
//                    ? Theme.of(context).accentColor
//                    : Colors.grey,
//                onPressed: () => setState(() => survey.health = Health.sick),
//              )),
//          SizedBox(
//              width: 110,
//              child: RaisedButton(
//                child: new Text('Unknown'),
//                textColor: Colors.white,
////                    shape: new RoundedRectangleBorder(
////                      borderRadius: new BorderRadius.circular(30.0),
////                    ),
//                color: survey.health == Health.undefined
//                    ? Theme.of(context).accentColor
//                    : Colors.grey,
//                onPressed: () =>
//                    setState(() => survey.health = Health.undefined),
//              ))
//        ],
//      )
//    ]);
  }



  List<Widget> createRadioListHealth() {
    List<Widget> widgets = List<Widget>();
    for (RespiratorySymptoms health in RespiratorySymptoms.values) {
      if (health != RespiratorySymptoms.undefined) {


        String text;
        if(health == RespiratorySymptoms.none) {
          text = "None";
        }else if(health == RespiratorySymptoms.mild) {
          text = "Mild";
        }else if(health == RespiratorySymptoms.moderate) {
          text = "Moderate (mild pneunomia)";
        }else if(health == RespiratorySymptoms.severe) {
          text = "Severe (dyspnoea, hypoxia)";
        }else if(health == RespiratorySymptoms.critical) {
          text = "Critical (respiratory failure)";
        }

        widgets.add(
          SizedBox(
              width: 200,
              child: RadioListTile(
                value: health,
                groupValue: survey.health,
                title: Text(text),
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
    
    widgets.insert(0, ListTile(
      title: Text("Respiratory Symptoms"),
//            subtitle: Text("Sex"),
    ));
    
    return widgets;
  }

  Widget healthDropDown() {
    return Column(
      children: createRadioListHealth(),
    );
  }

  Widget nextPageButton() {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Expanded(
                child: RaisedButton(
                  elevation: 0,
              child: Text(
                "Next: review",
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.title.color),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.of(context).pushNamed("/review_page");
              },
            ))
          ],
        ));
  }
}
