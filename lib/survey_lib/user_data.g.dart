// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final typeId = 1;

  @override
  UserSettings read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettings()..has_played_tutorial = fields[0] as bool;
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.has_played_tutorial);
  }
}
