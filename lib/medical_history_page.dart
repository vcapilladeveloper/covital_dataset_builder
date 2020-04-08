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
    survey = UserDataContainer
        .of(context)
        .data
        .current_survey;

    final ThemeData theme = Theme.of(context);

//    print("Video: " + survey.video_file.toString());

//    var bright = theme.brightness;
    String icon = 'assets/images/logo_dark.png';

    return Scaffold(
      appBar: AppBar(
        title: Text("CoVital - Data collection"),
      ),
      body: all(),
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
        Text("TODO")
      ],
    );
  }


  List<Widget> createRadioListHealth() {
    List<Widget> widgets = List<Widget>();
    for (Health health in Health.values) {
      if (health != Health.undefined) {
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
  }
}