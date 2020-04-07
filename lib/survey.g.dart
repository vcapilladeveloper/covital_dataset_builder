// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyDataExport _$SurveyDataExportFromJson(Map<String, dynamic> json) {
  return SurveyDataExport()
    ..id = json['id'] as String
    ..commercialDevice = json['commercialDevice'] == null
        ? null
        : CommercialDevice.fromJson(
            json['commercialDevice'] as Map<String, dynamic>)
    ..start_time_of_recording = json['start_time_of_recording'] == null
        ? null
        : DateTime.parse(json['start_time_of_recording'] as String)
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
    ..o2_gt = (json['o2_gt'] as num)?.toDouble()
    ..hr_gt = (json['hr_gt'] as num)?.toDouble()
    ..age = json['age'] as int
    ..weight = (json['weight'] as num)?.toDouble()
    ..sex = _$enumDecodeNullable(_$SexEnumMap, json['sex'])
    ..skin_color = json['skin_color'] as int
    ..health = _$enumDecodeNullable(_$HealthEnumMap, json['health'])
    ..phone_brand = json['phone_brand'] as String
    ..phone_reference = json['phone_reference'] as String;
}

Map<String, dynamic> _$SurveyDataExportToJson(SurveyDataExport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'commercialDevice': instance.commercialDevice,
      'start_time_of_recording':
          instance.start_time_of_recording?.toIso8601String(),
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
      'o2_gt': instance.o2_gt,
      'hr_gt': instance.hr_gt,
      'age': instance.age,
      'weight': instance.weight,
      'sex': _$SexEnumMap[instance.sex],
      'skin_color': instance.skin_color,
      'health': _$HealthEnumMap[instance.health],
      'phone_brand': instance.phone_brand,
      'phone_reference': instance.phone_reference,
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

const _$HealthEnumMap = {
  Health.undefined: 'undefined',
  Health.healthy: 'healthy',
  Health.recovering: 'recovering',
  Health.sick: 'sick',
};
