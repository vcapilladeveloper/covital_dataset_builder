import 'package:device_info/device_info.dart';

import 'dart:io';
import 'package:flutter/services.dart';

import 'package:json_annotation/json_annotation.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import 'commercial_device.dart';

import 'dart:core';

part 'survey.g.dart';





enum Sex{
  undefined,
  male,
  female,
}

enum Ethnicity{
  undefined,
  white,
  black,
  latino,
  asian,
}

enum RespiratorySymptoms{
  none,
  mild,
  moderate,
  severe,
  critical,
  undefined,
}


//@JsonSerializable()
class Survey extends SurveyDataExport{

  String video_file;

  Survey(){
    init();
  }


//  /// A necessary factory constructor for creating a new User instance
//  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
//  /// The constructor is named after the source class, in this case, User.
//  factory Survey.FromJson(Map<String, dynamic> json) => _$SurveyFromJson(json);
//
//  /// `toJson` is the convention for a class to declare support for serialization
//  /// to JSON. The implementation simply calls the private, generated
//  /// helper method `_$UserToJson`.
//  Map<String, dynamic> toJson() => _$SurveyToJson(this);
}

@JsonSerializable()
class SurveyDataExport{

  String id;

  CommercialDevice spo2Device;

  DateTime startTimeOfRecording;


  List<double> accelerometerValues = List<double>();
  List<double> userAccelerometerValues = List<double>();
  List<double> gyroscopeValues = List<double>();

  List<DateTime> accelerometerTimestamps = List<DateTime>();
  List<DateTime> gyroscopeTimestamps = List<DateTime>();
  List<DateTime> userAccelerometerTimestamps = List<DateTime>();

  double o2gt;
  double hrgt;

  int age;
  double weight;
  double height;

  File _user_file;
  String _user_file_path;

  Sex sex = Sex.undefined;
//  @deprecated
//  Ethnicity ethnicity = Ethnicity.undefinied;
  int skinColor;
  RespiratorySymptoms health = RespiratorySymptoms.undefined;

  String phoneBrand;
  String phoneModel;


  DateTime date;

  Map<String, dynamic> _deviceData;

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  SurveyDataExport(){
    init();
  }

  String get user_file_path{
    return _user_file_path;
  }

  File get user_file{
    return _user_file;
  }

  void init() async {


    try {
      if (Platform.isAndroid) {
        _deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        phoneBrand = _deviceData['brand'];
        phoneModel = _deviceData['model'];
      } else if (Platform.isIOS) {
        _deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        phoneModel = _deviceData['model'];
        phoneBrand = "iPhone";
      }
    } on PlatformException {
      _deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };

  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    _user_file_path = await _localPath;
    return File('$_user_file_path/user.txt');
  }

  Future<void> writeUserData() async {
    String json_survey = jsonEncode(this);
    print(json_survey);
    print("END");
    _user_file = await _localFile;
//    // Write the file.
    _user_file.writeAsString(json_survey);
  }


  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory SurveyDataExport.FromJson(Map<String, dynamic> json) => _$SurveyDataExportFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SurveyDataExportToJson(this);


  void clear(){
    clearSensorData();
    o2gt = null;
    hrgt = null;

    age = null;
    weight = null;
    height = null;

    _user_file = null;
    _user_file_path = null;

    date = null;

    sex = Sex.undefined;
//    ethnicity = Ethnicity.undefinied;
    health = RespiratorySymptoms.undefined;
    skinColor = null;

  }

  void clearSensorData(){
    accelerometerValues.clear();
    gyroscopeValues.clear();
    userAccelerometerValues.clear();
    accelerometerTimestamps.clear();
    userAccelerometerTimestamps.clear();
    gyroscopeTimestamps.clear();
  }

}