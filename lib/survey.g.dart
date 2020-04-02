// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyDataExport _$SurveyDataExportFromJson(Map<String, dynamic> json) {
  return SurveyDataExport()
    ..id = json['id'] as String
    ..accelerometerValues = (json['accelerometerValues'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList()
    ..userAccelerometerValues = (json['userAccelerometerValues'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList()
    ..gyroscopeValues = (json['gyroscopeValues'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList()
    ..o2_gt = (json['o2_gt'] as num)?.toDouble()
    ..hr_gt = (json['hr_gt'] as num)?.toDouble()
    ..age = json['age'] as int
    ..weight = (json['weight'] as num)?.toDouble()
    ..sex = _$enumDecodeNullable(_$SexEnumMap, json['sex'])
    ..ethni = _$enumDecodeNullable(_$EthnicityEnumMap, json['ethni'])
    ..phone_brand = json['phone_brand'] as String
    ..phone_reference = json['phone_reference'] as String;
}

Map<String, dynamic> _$SurveyDataExportToJson(SurveyDataExport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accelerometerValues': instance.accelerometerValues,
      'userAccelerometerValues': instance.userAccelerometerValues,
      'gyroscopeValues': instance.gyroscopeValues,
      'o2_gt': instance.o2_gt,
      'hr_gt': instance.hr_gt,
      'age': instance.age,
      'weight': instance.weight,
      'sex': _$SexEnumMap[instance.sex],
      'ethni': _$EthnicityEnumMap[instance.ethni],
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
  Sex.undefinied: 'undefinied',
  Sex.male: 'male',
  Sex.female: 'female',
};

const _$EthnicityEnumMap = {
  Ethnicity.undefinied: 'undefinied',
  Ethnicity.white: 'white',
  Ethnicity.black: 'black',
  Ethnicity.latino: 'latino',
  Ethnicity.asian: 'asian',
};
