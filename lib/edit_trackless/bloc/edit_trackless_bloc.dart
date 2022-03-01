import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trackless_repository/trackless_repository.dart';

part 'edit_trackless_event.dart';
part 'edit_trackless_state.dart';

class EditTracklessBloc extends Bloc<EditTracklessEvent, EditTracklessState> {
  EditTracklessBloc({
    Trackless? initialTrackless,
    required TracklessRepository tracklessRepository,
  })  : _tracklessRepository = tracklessRepository,
        super(
          EditTracklessState(
            initialTrackless: initialTrackless,
            name: initialTrackless?.name ?? Trackless.defaultName,
            code: initialTrackless?.code ?? 'J4',
            operativeHour: initialTrackless?.operativeHour ?? '13:00',
            inoperativeHour: initialTrackless?.inoperativeHour ?? '12:00',
            inoperativeHours: initialTrackless?.inoperativeHours ?? '1h 0m',
            observations: initialTrackless?.observations ?? 'Ok',
          ),
        ) {
    on<EditTracklessNameChanged>(_onNameChanged);
    on<EditTracklessCodeChanged>(_onCodeChanged);
    on<EditTracklessOperativeHourChanged>(_onOperativeHourChanged);
    on<EditTracklessInoperativeHourChanged>(_onInoperativeHourChanged);
    on<EditTracklessInoperativeHoursChanged>(_onInoperativeHoursChanged);
    on<EditTracklessObservationsChanged>(_onObservationsChanged);
    on<EditTracklessSubmitted>(_onSubmit);
  }

  final TracklessRepository _tracklessRepository;

  void _onNameChanged(
    EditTracklessNameChanged event,
    Emitter<EditTracklessState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onCodeChanged(
    EditTracklessCodeChanged event,
    Emitter<EditTracklessState> emit,
  ) {
    emit(state.copyWith(code: event.code));
  }

  void _onOperativeHourChanged(
    EditTracklessOperativeHourChanged event,
    Emitter<EditTracklessState> emit,
  ) {
    emit(state.copyWith(operativeHour: event.operativeHour));
    add(const EditTracklessInoperativeHoursChanged());
  }

  void _onInoperativeHourChanged(
    EditTracklessInoperativeHourChanged event,
    Emitter<EditTracklessState> emit,
  ) {
    emit(state.copyWith(inoperativeHour: event.inoperativeHour));
    add(const EditTracklessInoperativeHoursChanged());
  }

  void _onInoperativeHoursChanged(
    EditTracklessInoperativeHoursChanged event,
    Emitter<EditTracklessState> emit,
  ) {
    final h1 = state.inoperativeHour.split(':').map(int.parse).toList();
    final h2 = state.operativeHour.split(':').map(int.parse).toList();

    final hour = (h2.first - h1.first - (h2.last > h1.last ? 0 : 1)).abs();
    final minute =
        (h2.last > h1.last ? h2.last - h1.last : h2.last + (60 - h1.last))
            .abs();
    emit(state.copyWith(inoperativeHours: '${hour}h ${minute}m'));
  }

  void _onObservationsChanged(
    EditTracklessObservationsChanged event,
    Emitter<EditTracklessState> emit,
  ) {
    emit(state.copyWith(observations: event.observations));
  }

  Future<void> _onSubmit(
    EditTracklessSubmitted event,
    Emitter<EditTracklessState> emit,
  ) async {
    emit(state.copyWith(status: EditTracklessStatus.loading));
    final trackless = (state.initialTrackless ?? Trackless()).copyWith(
      name: state.name,
      code: state.code,
      operativeHour: state.operativeHour,
      inoperativeHour: state.inoperativeHour,
      inoperativeHours: state.inoperativeHours,
      observations: state.observations,
    );

    try {
      _tracklessRepository.saveTrackless(trackless);
      emit(state.copyWith(status: EditTracklessStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditTracklessStatus.failure));
    }
  }
}
