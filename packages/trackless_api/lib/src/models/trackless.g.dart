// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trackless.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trackless _$TracklessFromJson(Map<dynamic, dynamic> json) => Trackless(
      uid: json['uid'] as String?,
      name: json['name'] as String? ?? Trackless.defaultName,
      code: json['code'] as String? ?? '',
      date: json['date'] as String?,
      operativeHour: json['operativeHour'] as String? ?? '',
      inoperativeHour: json['inoperativeHour'] as String? ?? '',
      inoperativeHours: json['inoperativeHours'] as String? ?? '',
      observations: json['observations'] as String? ?? '',
    );

Map<String, dynamic> _$TracklessToJson(Trackless instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'code': instance.code,
      'date': instance.date,
      'operativeHour': instance.operativeHour,
      'inoperativeHour': instance.inoperativeHour,
      'inoperativeHours': instance.inoperativeHours,
      'observations': instance.observations,
    };
