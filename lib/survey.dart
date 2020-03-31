import 'package:device_info/device_info.dart';

import 'dart:io';
import 'package:flutter/services.dart';

enum Sex{
  undefinied,
  male,
  female,
}

enum Ethnicity{
  undefinied,
  white,
  black,
  latino,
  asian,
}

class Survey{

  String id;

  String video_file;

  List<double> accelerometerValues = List<double>();
  List<double> userAccelerometerValues = List<double>();
  List<double> gyroscopeValues = List<double>();

  double o2_gt;
  double hr_gt;

  int age;
  double weight;

  Sex sex = Sex.undefinied;
  Ethnicity ethni = Ethnicity.undefinied;

  String phone_brand;
  String phone_reference;

  Map<String, dynamic> deviceData;

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Survey(){
    init();
  }

  void init() async {


    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        phone_brand = deviceData['brand'];
        phone_reference = deviceData['model'];
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        phone_reference = deviceData['model'];
        phone_brand = "iPhone";
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
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


  void clearSensorData(){
    accelerometerValues.clear();
    gyroscopeValues.clear();
    userAccelerometerValues.clear();
  }

}