part of 'trackless_overview_bloc.dart';

abstract class TracklessOverviewEvent extends Equatable {
  const TracklessOverviewEvent();

  @override
  List<Object> get props => [];
}

class TracklessOverviewSubscriptionRequested extends TracklessOverviewEvent {
  const TracklessOverviewSubscriptionRequested();
}

class TracklessOverviewTracklessSaved extends TracklessOverviewEvent {
  const TracklessOverviewTracklessSaved(this.trackless);

  final Trackless trackless;

  @override
  List<Object> get props => [trackless];
}

class TracklessOverviewTracklessDeleted extends TracklessOverviewEvent {
  const TracklessOverviewTracklessDeleted(this.trackless);

  final Trackless trackless;

  @override
  List<Object> get props => [trackless];
}

class TracklessOverviewUndoDeletionRequested extends TracklessOverviewEvent {
  const TracklessOverviewUndoDeletionRequested();
}

class TracklessOverviewUndoExportRequested extends TracklessOverviewEvent {
  const TracklessOverviewUndoExportRequested();
}
