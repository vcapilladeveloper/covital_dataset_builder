import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/scheduler.dart';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';

import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:path/path.dart' as path_lib;
import 'package:http/http.dart';
import 'package:flutter/services.dart';

import 'package:openapi/api.dart';

import 'package:flutter_uploader/flutter_uploader.dart';

//import 'package:aws_s3/aws_s3.dart';
//import 'package:file_picker/file_picker.dart' as fp;
import 'package:image_picker/image_picker.dart' as ip;

import 'survey.dart';

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

  var api_instance = DefaultApi();

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

    survey = ModalRoute.of(context).settings.arguments;

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

  void onPressedSendButton(){
    if (survey.o2_gt == null || survey.hr_gt == null) {
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
    } else if (survey.o2_gt > 100 ||
        survey.o2_gt < 0 ||
        survey.hr_gt < 0) {
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

      Alert(
        context: context,
        type: AlertType.warning,
        title: "Warning",
        desc: "Posting the data is final.",
        buttons: [
          DialogButton(
            color: Theme.of(context).hintColor,
            child: Text(
              "Send",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await send_data();
              Navigator.of(context).pushReplacementNamed("/home");
            },
            width: 120,
          ),
          DialogButton(
            child: Text(
              "Keep editing",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();




    }
  }

  Widget all() {
    return ListView(
      children: <Widget>[

        deviceInfo(),

        Chewie(
          controller: _chewieController,
        ),

        GTMeasurements(),

        UserDataCard(),

        init_app
            ? FlatButton.icon(
          icon: Icon(Icons.send, color: Theme.of(context).accentColor,),
         label: Text("SEND", style: TextStyle(color: Theme.of(context).accentColor),),
        onPressed: onPressedSendButton,
      ) : Container(),

//        _controller.value.initialized
//              ? AspectRatio(
//            aspectRatio: _controller.value.aspectRatio,
//            child: VideoPlayer(_controller),
//          )
//              : Container(),
      ],
    );
  }

  Widget deviceInfo(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(survey.phone_brand),
        Text(survey.phone_reference),
//        Text(survey.deviceData['model'])
      ],
    );
  }

  Widget GTMeasurements() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("Ground truth measurements"),
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
                          survey.o2_gt = double.parse(s);
                        });
                      });
                    },
                    onSubmitted: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          survey.o2_gt = double.parse(s);
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
                          survey.hr_gt = double.parse(s);
                        });
                      });
                    },
                    onSubmitted: (String s) {
                      print("Submitted: " + s);
                      setState(() {
                        setState(() {
                          survey.hr_gt = double.parse(s);
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
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("User Data"),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("Sex"),
                        sexDropDown(),
                      ]),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("Ethnicity"),
                        ethnicityDropDown(),
                      ]),
                ],
              )),
        ));
  }

  Widget sexDropDown() {
    return DropdownButton<Sex>(
        value: survey.sex,
        onChanged: (Sex newValue) {
          setState(() {
            survey.sex = newValue;
          });
        },
        items: Sex.values.map((Sex sex) {
          return DropdownMenuItem<Sex>(value: sex, child: Text(sex.toString()));
        }).toList());
  }

  Widget ethnicityDropDown() {
    return DropdownButton<Ethnicity>(
        value: survey.ethni,
        onChanged: (Ethnicity newValue) {
          setState(() {
            survey.ethni = newValue;
          });
        },
        items: Ethnicity.values.map((Ethnicity ethni) {
          return DropdownMenuItem<Ethnicity>(value: ethni, child: Text(ethni.toString()));
        }).toList());
  }

  void send_data() async {
    print("Data sent: " + survey.video_file + " video");
//    var video = await ip.ImagePicker.pickVideo(source: ip.ImageSource.gallery);

    var video_path = path_lib.dirname(survey.video_file);
    var video_name = path_lib.basenameWithoutExtension(survey.video_file);
    var video_name_extension = path_lib.basename(survey.video_file);
    var extension = path_lib.extension(survey.video_file).split(".").last;

    String folder = video_name;
    String video_path_in_s3 = path_lib.join(folder, video_name);

    print("path " +
        video_path +
        " file " +
        video_path_in_s3 +
        " ext " +
        extension);
//    var path =
//    print(video.path);

    var fileItem = FileItem(
      filename: video_name_extension,
      savedDir: video_path,
      fieldname: "file",
    );

    Response response = await api_instance.getSignedUploadReqWithHttpInfo(
        video_path_in_s3, extension);
    print(response.body);
    var response_map = jsonDecode(response.body);
    String http_signed_address = response_map['result']['signedRequest'];

    final uploader = FlutterUploader();
//    var taskId = await uploader.enqueue(
//      url: http_signed_address,
////      data: {"name": "john"},
//      files: [fileItem],
//      method: UploadMethod.PUT,
////      tag: tag,
//      showNotification: true,
//    );
    var taskId = await uploader.enqueueBinary(
      url: http_signed_address,
      file: fileItem,
      method: UploadMethod.PUT,
//      tag: tag,
      showNotification: true,
    );
//
//    setState(() {
//      _tasks.putIfAbsent(
//          tag,
//              () => UploadItem(
//            id: taskId,
//            tag: tag,
//            type: MediaType.Video,
//            status: UploadTaskStatus.enqueued,
//          ));
//    });

//    print("Map: " + response_map['result']['signedRequest'].toString());
//
//    final uploader = FlutterUploader();
//    final taskId = await uploader.enqueue(
//        url: http_signed_address, //required: url to upload to
//        files: [FileItem(filename: "test_video.mp4", savedDir: video_file, fieldname:"file")], // required: list of files that you want to upload
//        method: UploadMethod.PUT, // HTTP method  (POST or PUT or PATCH)
////        headers: {"apikey": "api_123456", "userkey": "userkey_123456"},
//        data: {"name": "john"}, // any data you want to send in upload request
//        showNotification: true, // send local notification (android only) for upload status
//        tag: "upload 1"); // unique tag for upload task

//    uploadVideo();
  }

//  Future uploadVideo({@required bool binary}) async {
//    var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
//    if (video != null) {
//      final String savedDir = dirname(video.path);
//      final String filename = basename(video.path);
//      final tag = "video upload ${_tasks.length + 1}";
//      final url = _uploadUrl(binary: binary);
//
//      var fileItem = FileItem(
//        filename: filename,
//        savedDir: savedDir,
//        fieldname: "file",
//      );
//
//      var taskId = binary
//          ? await uploader.enqueueBinary(
//        url: url,
//        file: fileItem,
//        method: UploadMethod.POST,
//        tag: tag,
//        showNotification: true,
//      )
//          : await uploader.enqueue(
//        url: url,
//        data: {"name": "john"},
//        files: [fileItem],
//        method: UploadMethod.POST,
//        tag: tag,
//        showNotification: true,
//      );
//
//      setState(() {
//        _tasks.putIfAbsent(
//            tag,
//                () => UploadItem(
//              id: taskId,
//              tag: tag,
//              type: MediaType.Video,
//              status: UploadTaskStatus.enqueued,
//            ));
//      });
//    }
//  }
//
//

//  Future<String> _uploadvideo(String fileName, int number,
//      {String extension = 'jpg'}) async {
//
//    String result;
//
//    if (result == null) {
//      // generating file name
////      String fileName =
////          "$number$extension\_${DateTime.now().millisecondsSinceEpoch}.$extension";
//
//      AwsS3 awsS3 = AwsS3(
//          awsFolderPath: awsFolderPath,
//          file: await fp.FilePicker.getFile(type: fp.FileType.video),
//          fileNameWithExt: fileName,
//          poolId: poolId,
//          region: Regions.AP_SOUTHEAST_2,
//          bucketName: bucketName);
//
//      setState(() => isFileUploading = true);
//      displayUploadDialog(awsS3);
//      try {
//        try {
//          result = await awsS3.uploadFile;
//          debugPrint("Result :'$result'.");
//        } on PlatformException {
//          debugPrint("Result :'$result'.");
//        }
//      } on PlatformException catch (e) {
//        debugPrint("Failed :'${e.message}'.");
//      }
//    }
//    Navigator.of(context).pop();
//    return result;
//  }
//
//  Future displayUploadDialog(AwsS3 awsS3) {
//    return showDialog(
//      context: context,
//      barrierDismissible: false,
//      builder: (context) => StreamBuilder(
//        stream: awsS3.getUploadStatus,
//        builder: (BuildContext context, AsyncSnapshot snapshot) {
//          return buildFileUploadDialog(snapshot, context);
//        },
//      ),
//    );
//  }
//
//  AlertDialog buildFileUploadDialog(
//      AsyncSnapshot snapshot, BuildContext context) {
//    return AlertDialog(
//      title: Container(
//        padding: EdgeInsets.all(6),
//        child: LinearProgressIndicator(
//          value: (snapshot.data != null) ? snapshot.data / 100 : 0,
//          valueColor:
//          AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColorDark),
//        ),
//      ),
//      content: Padding(
//        padding: const EdgeInsets.symmetric(horizontal: 6),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: [
//            Expanded(child: Text('Uploading...')),
//            Text("${snapshot.data ?? 0}%"),
//          ],
//        ),
//      ),
//    );
//  }
}
