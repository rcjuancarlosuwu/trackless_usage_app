import 'dart:async';

import 'package:trackless_api/trackless_api.dart';

/// {@template trackless_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class TracklessRepository {
  /// {@macro trackless_repository}
  const TracklessRepository({
    required TracklessApi tracklessApi,
  }) : _tracklessApi = tracklessApi;

  final TracklessApi _tracklessApi;

  ///
  Stream<List<Trackless>> getTrackless() => _tracklessApi.getTrackless();

  ///
  FutureOr<void> saveTrackless(Trackless trackless) =>
      _tracklessApi.saveTrackless(trackless);

  ///
  FutureOr<void> deleteTrackless(String uid) =>
      _tracklessApi.deleteTrackless(uid);
}
