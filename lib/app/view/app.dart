// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trackless_repository/trackless_repository.dart';

import 'package:trackless_usage_app/l10n/l10n.dart';
import 'package:trackless_usage_app/trackless_overview/view/trackless_overview_page.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.tracklessRepository,
  }) : super(key: key);

  final TracklessRepository tracklessRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => tracklessRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(centerTitle: true),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const TracklessOverviewPage(),
    );
  }
}
