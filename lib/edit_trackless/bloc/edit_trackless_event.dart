part of 'edit_trackless_bloc.dart';

abstract class EditTracklessEvent extends Equatable {
  const EditTracklessEvent();

  @override
  List<Object> get props => [];
}

class EditTracklessNameChanged extends EditTracklessEvent {
  const EditTracklessNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class EditTracklessCodeChanged extends EditTracklessEvent {
  const EditTracklessCodeChanged(this.code);

  final String code;

  @override
  List<Object> get props => [code];
}

class EditTracklessOperativeHourChanged extends EditTracklessEvent {
  const EditTracklessOperativeHourChanged(this.operativeHour);

  final String operativeHour;

  @override
  List<Object> get props => [operativeHour];
}

class EditTracklessInoperativeHourChanged extends EditTracklessEvent {
  const EditTracklessInoperativeHourChanged(this.inoperativeHour);

  final String inoperativeHour;

  @override
  List<Object> get props => [inoperativeHour];
}

class EditTracklessInoperativeHoursChanged extends EditTracklessEvent {
  const EditTracklessInoperativeHoursChanged();
}

class EditTracklessObservationsChanged extends EditTracklessEvent {
  const EditTracklessObservationsChanged(this.observations);

  final String observations;

  @override
  List<Object> get props => [observations];
}

class EditTracklessSubmitted extends EditTracklessEvent {
  const EditTracklessSubmitted();
}
