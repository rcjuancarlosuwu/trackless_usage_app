import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/subjects.dart';
import 'package:trackless_api/trackless_api.dart';

/// {@template hive_trackless_api}
/// [HiveTracklessApi] implementation of [TracklessApi]
/// {@endtemplate}
class HiveTracklessApi extends TracklessApi {
  /// {@macro hive_trackless_api}
  HiveTracklessApi() {
    _init();
  }

  /// [Box] name
  static const tracklessBoxName = '__trackless_box_name__';

  late final Box _box;
  final _tracklessStreamController =
      BehaviorSubject<List<Trackless>>.seeded(const []);

  Future<void> _init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(tracklessBoxName);
    final tracklessList = _box.values
        .map(
          (e) => Trackless.fromJson(e as Map<dynamic, dynamic>),
        )
        .toList();
    _tracklessStreamController.add(tracklessList);
  }

  @override
  FutureOr<void> deleteTrackless(String uid) {
    final tracklessList = List.of(_tracklessStreamController.value);
    final tracklessIndex = tracklessList.indexWhere((e) => e.uid == uid);
    if (tracklessIndex == -1) {
      throw TracklessNotFoundException();
    } else {
      tracklessList.removeAt(tracklessIndex);
      _box.delete(uid);
      _tracklessStreamController.add(tracklessList);
    }
  }

  @override
  Stream<List<Trackless>> getTrackless() =>
      _tracklessStreamController.asBroadcastStream();

  @override
  FutureOr<void> saveTrackless(Trackless trackless) {
    final tracklessList = List.of(_tracklessStreamController.value);
    final tracklessIndex = tracklessList.indexWhere(
      (e) => e.uid == trackless.uid,
    );
    if (tracklessIndex == -1) {
      tracklessList.add(trackless);
    } else {
      tracklessList[tracklessIndex] = trackless;
    }
    _tracklessStreamController.add(tracklessList);
    _box.put(trackless.uid, trackless.toJson());
  }
}
