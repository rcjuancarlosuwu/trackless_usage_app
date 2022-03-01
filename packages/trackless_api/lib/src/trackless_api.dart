import 'dart:async';

import 'package:trackless_api/src/models/models.dart';

///
class TracklessNotFoundException implements Exception {}

/// {@template trackless_api}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract class TracklessApi {
  /// {@macro trackless_api}
  const TracklessApi();

  ///
  Stream<List<Trackless>> getTrackless();

  ///
  FutureOr<void> saveTrackless(Trackless trackless);

  ///
  FutureOr<void> deleteTrackless(String uid);
}
