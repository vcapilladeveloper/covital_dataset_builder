import 'package:covital_dataset_builder/O2process/O2process.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../user_data_container.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'dart:typed_data';

import 'package:video_player/video_player.dart';

import 'package:image/image.dart' as imglib;
import 'package:flutter/services.dart';


class O2ProcessPage extends StatefulWidget {
  @override
  _O2ProcessPageState createState() => new _O2ProcessPageState();
}

class _O2ProcessPageState extends State<O2ProcessPage> {
  int frame_nb;
  List<FileSystemEntity> files;

//  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
//    _controller = VideoPlayerController.asset('assets/S98T89.mp4')
//      ..initialize().then((_) {
//        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//        setState(() {});
//      });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      runInitTasks();
    });
  }

  @protected
  Future runInitTasks() async {


    //Get all frames!

    await UserDataContainer.of(context).data.initialize();
    String video_path = UserDataContainer.of(context).data.last_video;
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test/frames';
    var dir = await Directory(dirPath).create(recursive: true);

//    ffmpeg -i file.mpg -r 1/1 $filename%03d.jpg
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();


    _flutterFFmpeg
        .execute("-i " + "assets/S98T89.mp4" + " " + dirPath + "/frame%04d.jpg")
        .then((rc) => print("FFmpeg process exited with rc $rc"));

    files = dir.listSync();
    for (var el in files) {
      print(el.toString());
    }
    frame_nb = files.length;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String video_path = UserDataContainer.of(context).data.last_video;
    final ThemeData theme = Theme.of(context);
//    var bright = theme.brightness;
    String icon = 'assets/images/logo_dark.png';

    return Scaffold(
      appBar: AppBar(),
      body:

//      Center(
//        child: _controller.value.initialized
//            ? AspectRatio(
//                aspectRatio: _controller.value.aspectRatio,
//                child: VideoPlayer(_controller),
//              )
//            : Container(),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          setState(() {
//            _controller.value.isPlaying
//                ? _controller.pause()
//                : _controller.play();
//          });
//        },
//        child: Icon(
//          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//        ),
//      ),

      FutureBuilder<int>(
        future: getO2(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot){
          if(snapshot.hasData){

            return Text("Yeah : " + snapshot.data.toString());
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<int> getO2() async {
    O2Process o2 = O2Process();
    List<imglib.Image> images = List<imglib.Image>();

    for (var el in files) {
      imglib.Image image = imglib.decodeImage(File(el.path).readAsBytesSync());
      images.add(image);
    }

    var o2_result = o2.processStackOfFrames(images, 30);

    return o2_result;
  }
}
