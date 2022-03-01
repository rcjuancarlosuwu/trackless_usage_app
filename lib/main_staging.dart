// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:hive_trackless_api/hive_trackless_api.dart';
import 'package:trackless_usage_app/bootstrap.dart';

void main() {
  final tracklessApi = HiveTracklessApi();

  bootstrap(tracklessApi: tracklessApi);
}
