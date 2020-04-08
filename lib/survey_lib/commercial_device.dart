//import 'package:device_info/device_info.dart';
//
//import 'dart:io';
//import 'package:flutter/services.dart';
//
import 'package:json_annotation/json_annotation.dart';
//
//import 'package:path_provider/path_provider.dart';
//import 'dart:convert';

import 'package:hive/hive.dart';

part 'commercial_device.g.dart';


Future registerHiveCommercialDevice(){
  Hive.registerAdapter(CommercialDeviceAdapter());
}



@JsonSerializable()
@HiveType(typeId: 0)
class CommercialDevice extends HiveObject{
  @HiveField(0)
  String brand;
  @HiveField(1)
  String model;

  CommercialDevice();

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory CommercialDevice.fromJson(Map<String, dynamic> json) => _$CommercialDeviceFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CommercialDeviceToJson(this);


}