part of 'trackless_overview_bloc.dart';

enum TracklessOverviewStatus { initial, loading, success, failure }

class TracklessOverviewState extends Equatable {
  const TracklessOverviewState({
    this.status = TracklessOverviewStatus.initial,
    this.trackless = const <Trackless>[],
    this.lastDeletedTrackless,
  });

  final TracklessOverviewStatus status;
  final List<Trackless> trackless;
  final Trackless? lastDeletedTrackless;

  @override
  List<Object?> get props => [status, trackless, lastDeletedTrackless];

  TracklessOverviewState copyWith({
    TracklessOverviewStatus Function()? status,
    List<Trackless> Function()? trackless,
    Trackless? Function()? lastDeletedTrackless,
  }) {
    return TracklessOverviewState(
      status: status != null ? status() : this.status,
      trackless: trackless != null ? trackless() : this.trackless,
      lastDeletedTrackless: lastDeletedTrackless != null
          ? lastDeletedTrackless()
          : this.lastDeletedTrackless,
    );
  }
}
