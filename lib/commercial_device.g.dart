// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commercial_device.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommercialDeviceAdapter extends TypeAdapter<CommercialDevice> {
  @override
  final typeId = 0;

  @override
  CommercialDevice read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommercialDevice()
      ..brand = fields[0] as String
      ..model = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, CommercialDevice obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.brand)
      ..writeByte(1)
      ..write(obj.model);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommercialDevice _$CommercialDeviceFromJson(Map<String, dynamic> json) {
  return CommercialDevice()
    ..brand = json['brand'] as String
    ..model = json['model'] as String;
}

Map<String, dynamic> _$CommercialDeviceToJson(CommercialDevice instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'model': instance.model,
    };
