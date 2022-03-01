import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'trackless.g.dart';

///
@JsonSerializable()
class Trackless extends Equatable {
  ///
  Trackless({
    String? uid,
    this.name = defaultName,
    this.code = '',
    String? date,
    this.operativeHour = '',
    this.inoperativeHour = '',
    this.inoperativeHours = '',
    this.observations = '',
  }) : uid = uid ?? const Uuid().v4() {
    final now = DateTime.now();
    this.date = date ?? '${now.day}/${now.month}/${now.year}';
  }

  ///
  static const defaultName = 'JUMBO-F';

  ///
  static const names = [
    'JUMBO-F',
    'JUMBO-E',
    'SCOOP',
    'SCALER',
    'MANITOU',
    'CAMIONTA',
    'CAMION',
    'MIXER',
    'ALPHA',
  ];

  ///
  final String uid;

  ///
  final String name;

  ///
  final String code;

  ///
  late final String date;

  ///
  final String operativeHour;

  ///
  final String inoperativeHour;

  ///
  final String inoperativeHours;

  ///
  final String observations;

  @override
  List<Object> get props {
    return [
      uid,
      name,
      code,
      date,
      operativeHour,
      inoperativeHour,
      inoperativeHours,
      observations,
    ];
  }

  ///
  Trackless copyWith({
    String? uid,
    String? name,
    String? code,
    String? date,
    String? operativeHour,
    String? inoperativeHour,
    String? inoperativeHours,
    String? observations,
  }) {
    return Trackless(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      code: code ?? this.code,
      date: date ?? this.date,
      operativeHour: operativeHour ?? this.operativeHour,
      inoperativeHour: inoperativeHour ?? this.inoperativeHour,
      inoperativeHours: inoperativeHours ?? this.inoperativeHours,
      observations: observations ?? this.observations,
    );
  }

  ///
  static Trackless fromJson(Map<dynamic, dynamic> json) =>
      _$TracklessFromJson(json);

  ///
  Map<String, dynamic> toJson() => _$TracklessToJson(this);
}
