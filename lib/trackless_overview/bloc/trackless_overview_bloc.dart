import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trackless_repository/trackless_repository.dart';

part 'trackless_overview_event.dart';
part 'trackless_overview_state.dart';

class TracklessOverviewBloc
    extends Bloc<TracklessOverviewEvent, TracklessOverviewState> {
  TracklessOverviewBloc({
    required TracklessRepository tracklessRepository,
  })  : _tracklessRepository = tracklessRepository,
        super(const TracklessOverviewState()) {
    on<TracklessOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<TracklessOverviewTracklessSaved>(_onTracklessSaved);
    on<TracklessOverviewTracklessDeleted>(_onTracklessDeleted);
    on<TracklessOverviewUndoDeletionRequested>(_onUndoDeletionRequested);
    on<TracklessOverviewUndoExportRequested>(_onExportRequested);
  }

  final TracklessRepository _tracklessRepository;

  Future<void> _onSubscriptionRequested(
    TracklessOverviewSubscriptionRequested event,
    Emitter<TracklessOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => TracklessOverviewStatus.loading));

    await emit.forEach<List<Trackless>>(
      _tracklessRepository.getTrackless(),
      onData: (trackless) => state.copyWith(
        status: () => TracklessOverviewStatus.success,
        trackless: () => trackless,
      ),
      onError: (_, __) => state.copyWith(
        status: () => TracklessOverviewStatus.failure,
      ),
    );
  }

  Future<void> _onTracklessSaved(
    TracklessOverviewTracklessSaved event,
    Emitter<TracklessOverviewState> emit,
  ) async {
    await _tracklessRepository.saveTrackless(event.trackless);
  }

  Future<void> _onTracklessDeleted(
    TracklessOverviewTracklessDeleted event,
    Emitter<TracklessOverviewState> emit,
  ) async {
    emit(state.copyWith(lastDeletedTrackless: () => event.trackless));
    await _tracklessRepository.deleteTrackless(event.trackless.uid);
  }

  Future<void> _onUndoDeletionRequested(
    TracklessOverviewUndoDeletionRequested event,
    Emitter<TracklessOverviewState> emit,
  ) async {
    final trackless = state.lastDeletedTrackless!;
    emit(state.copyWith(lastDeletedTrackless: () => null));
    await _tracklessRepository.saveTrackless(trackless);
  }

  Future<void> _onExportRequested(
    TracklessOverviewUndoExportRequested event,
    Emitter<TracklessOverviewState> emit,
  ) async {
    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];

    for (var i = 0; i < state.trackless.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i))
          .value = state.trackless[i].date;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i))
          .value = state.trackless[i].name;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i))
          .value = state.trackless[i].code;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i))
          .value = state.trackless[i].inoperativeHour;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i))
          .value = state.trackless[i].operativeHour;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i))
          .value = state.trackless[i].inoperativeHours;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: i))
          .value = state.trackless[i].observations;
    }

    final fileBytes = excel.encode();

    if (fileBytes != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/export.xlsx';
      final file = await File(path).create();
      await file.writeAsBytes(fileBytes);
      await Share.shareFiles([file.path], text: 'Excel');
    }
  }
}
