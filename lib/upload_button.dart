import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart' as path_lib;
import 'package:http/http.dart';

import 'package:openapi/api.dart' as upload_api;

import 'package:flutter_uploader/flutter_uploader.dart';

import 'survey_lib/survey.dart';

enum MediaType { Image, Video }

class FileToSend {
  upload_api.SignedUploadFiles file = upload_api.SignedUploadFiles();
  Map<String, dynamic> signed_url;

  String file_name_with_extension;
  String file_path;
  bool is_video;

  FileToSend({this.file_path, this.file_name_with_extension, this.is_video});

  Future<String> send_data(FlutterUploader uploader) async {
    FileItem fileItem = FileItem(
      filename: file_name_with_extension,
      savedDir: file_path,
      fieldname: "file",

    );
    print("Sending the data: " +
        fileItem.filename +
        " " +
        fileItem.savedDir +
        " " +
        fileItem.fieldname);
//    final uploader = FlutterUploader();
    if (is_video) {
      return await uploader.enqueueBinary(
        url: signed_url['signedRequest'],
        file: fileItem,
        method: UploadMethod.PUT,
        tag: "video",
        showNotification: true,
      );
    } else {
      return await uploader.enqueueBinary(
        url: signed_url['signedRequest'],
//        data: {"name": "john"},
        file: fileItem,
        method: UploadMethod.PUT,
        tag: "userfile",
//        showNotification: true,
      );
    }
  }
}

class UploadItem {
  final String id;
  final String tag;
  final MediaType type;
  final int progress;
  final UploadTaskStatus status;

  UploadItem({
    this.id,
    this.tag,
    this.type,
    this.progress = 0,
    this.status = UploadTaskStatus.undefined,
  });

  UploadItem copyWith({UploadTaskStatus status, int progress}) => UploadItem(
      id: this.id,
      tag: this.tag,
      type: this.type,
      status: status ?? this.status,
      progress: progress ?? this.progress);

  bool isCompleted() =>
      this.status == UploadTaskStatus.canceled ||
      this.status == UploadTaskStatus.complete ||
      this.status == UploadTaskStatus.failed;
}

class UploadButton extends StatefulWidget {
  Survey survey;
  final ValueChanged<double> updateProgress;
  final ValueChanged<bool> isUploading;

  UploadButton({Key key, this.survey, this.updateProgress, this.isUploading}) : super(key: key);

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  FlutterUploader uploader = FlutterUploader();
  StreamSubscription _progressSubscription;
  StreamSubscription _resultSubscription;
  Map<String, UploadItem> _tasks = {};

  bool _started_upload = false;
  bool is_done_uploading_video = false;
  bool is_done_uploading_userdata = false;
  var api_instance = upload_api.DefaultApi();

  double progress_value = 0;


  @override
  void initState() {
    super.initState();

    _progressSubscription = uploader.progress.listen((progress) {
      final task = _tasks[progress.tag];
      print("progress: ${progress.progress} , tag: ${progress.tag}");
      if (progress.tag == "video") {
        widget.updateProgress(progress_value);
        setState(() {
          progress_value = progress.progress.toDouble() / 100;
        });
      }
    });

    _resultSubscription = uploader.result.listen((result) {
      print(
          "id: ${result.taskId}, status: ${result.status}, response: ${result.response}, statusCode: ${result.statusCode}, tag: ${result.tag}, headers: ${result.headers}");

      final task = _tasks[result.tag];
      if (task == null) {
        print("Task is null");
        return;
      }

      print(is_done_uploading_video.toString() +
          " and " +
          is_done_uploading_userdata.toString() +
          " " +
          _started_upload.toString());
      setState(() {
        print("Changing task");
        _tasks[result.tag] = task.copyWith(status: result.status);

        if (result.tag == "video") {
          is_done_uploading_video = true;
        } else if (result.tag == "userfile") {
          is_done_uploading_userdata = true;
        }
        if (is_done_uploading_video && is_done_uploading_userdata) {
          _started_upload = false;
          is_done_uploading_video = false;
          is_done_uploading_userdata = false;
          progress_value = 0;

          widget.survey.clear();

          Navigator.of(context).pushNamedAndRemoveUntil(
              "/thank_you", (Route<dynamic> route) => false);
        }
      });
    }, onError: (ex, stacktrace) {
      print("exception: $ex");
      print("stacktrace: $stacktrace" ?? "no stacktrace");
      final exp = ex as UploadException;
      final task = _tasks[exp.tag];
      if (task == null) return;

      setState(() {
        _tasks[exp.tag] = task.copyWith(status: exp.status);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _progressSubscription?.cancel();
    _resultSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {


//    var w = List<Widget>();
//
//    if (_started_upload == true) {
//      w.add(LinearProgressIndicator(
//        value: progress_value,
//      ));
//    }

//    w.add(
      return Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(children: <Widget>[

          Expanded(
          child:
          FlatButton(
//            icon: Icon(Icons.edit,
//                color: Theme.of(context).accentColor
////          color: Theme.of(context).accentColor,
//            ),
            child: Text(
              "Edit",
              style: TextStyle(
                  color: Theme.of(context).accentColor),
            ),
//            color: Theme.of(context).accentColor,
            onPressed: (){
              Navigator.of(context).pushReplacementNamed("/gtpage");
            }
          )
          ),

            SizedBox(width: 10),

            Expanded(
                child:

               RaisedButton(
                 elevation: 0,
//              icon: Icon(Icons.send,
//                  color: Theme.of(context).primaryTextTheme.title.color
////          color: Theme.of(context).accentColor,
//                  ),
              child: Text(
                "Submit",
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.title.color),
              ),
              color: Theme.of(context).accentColor,
              onPressed: _started_upload ? null : onPressedSendButton,
            )
                )
          ]));
//    );

//    for (var el in _tasks.keys) {
//      final item = _tasks[el];
//      print("${item.tag} - ${item.status}");
//
//      w.add(UploadItemView(
//        item: item,
//        onCancel: cancelUpload,
//      ));
//    }

//    return Column(children: w);
  }

  void send_data() async {
    setState(() {
      _started_upload = true;
    });
    widget.isUploading(_started_upload);

    print("Data sent: " + widget.survey.video_file + " video");
//    var video = await ip.ImagePicker.pickVideo(source: ip.ImageSource.gallery);

    var video_path = path_lib.dirname(widget.survey.video_file);
//    var video_name = path_lib.basenameWithoutExtension(survey.video_file);
    var video_name_extension = path_lib.basename(widget.survey.video_file);
    var extension =
        path_lib.extension(widget.survey.video_file).split(".").last;

//    String folder = video_name;
//    String video_path_in_s3 = path_lib.join(folder, video_name);

    upload_api.InlineObject inline_object = upload_api.InlineObject();

//    inline_object.source_ = "community";
    inline_object.source_ = "clinical";

    widget.survey.date = DateTime.now();

    List<FileToSend> files_to_send = List<FileToSend>();

    FileToSend f_video = FileToSend(
        file_name_with_extension: video_name_extension,
        file_path: video_path,
        is_video: true);
    f_video.file.name = widget.survey.date.toString();
    f_video.file.extension_ = extension;

    inline_object.files.add(f_video.file);
    files_to_send.add(f_video);

    //Write user data to file
    await widget.survey.writeUserData();

    FileToSend f_user = FileToSend(
        file_name_with_extension:
            path_lib.basename(widget.survey.user_file.path),
        file_path: widget.survey.user_file_path,
        is_video: false);
    f_user.file.name = "user";
    f_user.file.extension_ = "json";
    inline_object.files.add(f_user.file);
    files_to_send.add(f_user);

    Response response =
        await api_instance.batchSignedUploadReqWithHttpInfo(inline_object);
    print(response.body);
    var response_map = jsonDecode(response.body);
    widget.survey.id = response_map['surveyId'];

    //Write user data to file
    await widget.survey.writeUserData();


    for (var el in response_map['signedRequests']) {
      for (var el_file in files_to_send) {
        if (el_file.file.name == el['name']) {
          el_file.signed_url = el;
          print("file name " + el_file.file.name);
          print(el_file.signed_url['signedRequest']);
        }
      }
    }

    for (var file in files_to_send) {
      print("Sending file");
      var taskID = await file.send_data(uploader);
      String tag;
      if (file.is_video) {
        tag = "video";
      } else {
        tag = "userfile";
      }
      setState(() {
        _tasks.putIfAbsent(
            tag,
            () => UploadItem(
                  id: taskID,
                  tag: tag,
                  type: MediaType.Video,
                  status: UploadTaskStatus.enqueued,
                ));
      });
    }
  }

  void onPressedSendButton() {
    if (widget.survey.spo2 == null || widget.survey.hr == null) {
      print("need gt data");
      Fluttertoast.showToast(
          msg: "please input data ground truth data for SpO2 and HR",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
//                timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).accentColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (widget.survey.spo2 > 100 ||
        widget.survey.spo2 < 0 ||
        widget.survey.hr < 0) {
      print("need gt data");
      Fluttertoast.showToast(
          msg: "please input valid data ground truth data for SpO2 and HR",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
//                timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).accentColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      send_data();
//      Alert(
//        context: context,
//        type: AlertType.warning,
//        title: "Warning",
//        desc: "Posting the data is final.",
//        buttons: [
//          DialogButton(
//            color: Theme.of(context).hintColor,
//            child: Text(
//              "Send",
//              style: TextStyle(color: Colors.white, fontSize: 20),
//            ),
//            onPressed: () async {
//              Navigator.pop(context);
//              await send_data();
//
////              Navigator.of(context).pushReplacementNamed("/home");
//            },
//            width: 120,
//          ),
//          DialogButton(
//            child: Text(
//              "Keep editing",
//              style: TextStyle(color: Colors.white, fontSize: 20),
//            ),
//            onPressed: () => Navigator.pop(context),
//            width: 120,
//          )
//        ],
//      ).show();
    }
  }

  Future cancelUpload(String id) async {
    await uploader.cancel(taskId: id);
  }
}

typedef CancelUploadCallback = Future<void> Function(String id);

class UploadItemView extends StatelessWidget {
  final UploadItem item;
  final CancelUploadCallback onCancel;

  UploadItemView({
    Key key,
    this.item,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = item.progress.toDouble() / 100;
    final widget = item.status == UploadTaskStatus.running
        ? LinearProgressIndicator(value: progress)
        : Container();
    final buttonWidget = item.status == UploadTaskStatus.running
        ? Container(
            height: 50,
            width: 50,
            child: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () => onCancel(item.id),
            ),
          )
        : Container();
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(item.tag),
              Container(
                height: 5.0,
              ),
              Text(item.status.description),
              Container(
                height: 5.0,
              ),
              widget
            ],
          ),
        ),
        buttonWidget
      ],
    );
  }
}
