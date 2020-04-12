// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyDataExport _$SurveyDataExportFromJson(Map<String, dynamic> json) {
  return SurveyDataExport()
    ..id = json['id'] as String
    ..spo2Device = json['spo2Device'] == null
        ? null
        : CommercialDevice.fromJson(json['spo2Device'] as Map<String, dynamic>)
    ..startTimeOfRecording = json['startTimeOfRecording'] == null
        ? null
        : DateTime.parse(json['startTimeOfRecording'] as String)
    ..accelerometerValues = (json['accelerometerValues'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList()
    ..userAccelerometerValues = (json['userAccelerometerValues'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList()
    ..gyroscopeValues = (json['gyroscopeValues'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList()
    ..accelerometerTimestamps = (json['accelerometerTimestamps'] as List)
        ?.map((e) => e == null ? null : DateTime.parse(e as String))
        ?.toList()
    ..gyroscopeTimestamps = (json['gyroscopeTimestamps'] as List)
        ?.map((e) => e == null ? null : DateTime.parse(e as String))
        ?.toList()
    ..userAccelerometerTimestamps =
        (json['userAccelerometerTimestamps'] as List)
            ?.map((e) => e == null ? null : DateTime.parse(e as String))
            ?.toList()
    ..o2gt = (json['o2gt'] as num)?.toDouble()
    ..hrgt = (json['hrgt'] as num)?.toDouble()
    ..age = json['age'] as int
    ..weight = (json['weight'] as num)?.toDouble()
    ..height = (json['height'] as num)?.toDouble()
    ..sex = _$enumDecodeNullable(_$SexEnumMap, json['sex'])
    ..skinColor = json['skinColor'] as int
    ..health =
        _$enumDecodeNullable(_$RespiratorySymptomsEnumMap, json['health'])
    ..phoneBrand = json['phoneBrand'] as String
    ..phoneModel = json['phoneModel'] as String
    ..date =
        json['date'] == null ? null : DateTime.parse(json['date'] as String);
}

Map<String, dynamic> _$SurveyDataExportToJson(SurveyDataExport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'spo2Device': instance.spo2Device,
      'startTimeOfRecording': instance.startTimeOfRecording?.toIso8601String(),
      'accelerometerValues': instance.accelerometerValues,
      'userAccelerometerValues': instance.userAccelerometerValues,
      'gyroscopeValues': instance.gyroscopeValues,
      'accelerometerTimestamps': instance.accelerometerTimestamps
          ?.map((e) => e?.toIso8601String())
          ?.toList(),
      'gyroscopeTimestamps': instance.gyroscopeTimestamps
          ?.map((e) => e?.toIso8601String())
          ?.toList(),
      'userAccelerometerTimestamps': instance.userAccelerometerTimestamps
          ?.map((e) => e?.toIso8601String())
          ?.toList(),
      'o2gt': instance.o2gt,
      'hrgt': instance.hrgt,
      'age': instance.age,
      'weight': instance.weight,
      'height': instance.height,
      'sex': _$SexEnumMap[instance.sex],
      'skinColor': instance.skinColor,
      'health': _$RespiratorySymptomsEnumMap[instance.health],
      'phoneBrand': instance.phoneBrand,
      'phoneModel': instance.phoneModel,
      'date': instance.date?.toIso8601String(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$SexEnumMap = {
  Sex.undefined: 'undefined',
  Sex.male: 'male',
  Sex.female: 'female',
};

const _$RespiratorySymptomsEnumMap = {
  RespiratorySymptoms.none: 'none',
  RespiratorySymptoms.mild: 'mild',
  RespiratorySymptoms.moderate: 'moderate',
  RespiratorySymptoms.severe: 'severe',
  RespiratorySymptoms.critical: 'critical',
  RespiratorySymptoms.undefined: 'undefined',
};
