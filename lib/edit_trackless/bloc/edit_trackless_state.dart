part of 'edit_trackless_bloc.dart';

enum EditTracklessStatus { initial, loading, success, failure }

extension EditTracklessStatusX on EditTracklessStatus {
  bool get isLoadingOrSuccess => [
        EditTracklessStatus.loading,
        EditTracklessStatus.success,
      ].contains(this);
}

class EditTracklessState extends Equatable {
  const EditTracklessState({
    this.initialTrackless,
    this.status = EditTracklessStatus.initial,
    this.name = Trackless.defaultName,
    required this.code,
    required this.operativeHour,
    required this.inoperativeHour,
    required this.inoperativeHours,
    required this.observations,
  });

  final Trackless? initialTrackless;
  final EditTracklessStatus status;
  final String name;
  final String code;
  final String operativeHour;
  final String inoperativeHour;
  final String inoperativeHours;
  final String observations;

  bool get isNewTrackless => initialTrackless == null;

  @override
  List<Object?> get props {
    return [
      initialTrackless,
      status,
      name,
      code,
      operativeHour,
      inoperativeHour,
      inoperativeHours,
      observations,
    ];
  }

  EditTracklessState copyWith({
    Trackless? initialTrackless,
    EditTracklessStatus? status,
    String? name,
    String? code,
    String? operativeHour,
    String? inoperativeHour,
    String? inoperativeHours,
    String? observations,
  }) {
    return EditTracklessState(
      initialTrackless: initialTrackless ?? this.initialTrackless,
      status: status ?? this.status,
      name: name ?? this.name,
      code: code ?? this.code,
      operativeHour: operativeHour ?? this.operativeHour,
      inoperativeHour: inoperativeHour ?? this.inoperativeHour,
      inoperativeHours: inoperativeHours ?? this.inoperativeHours,
      observations: observations ?? this.observations,
    );
  }
}
