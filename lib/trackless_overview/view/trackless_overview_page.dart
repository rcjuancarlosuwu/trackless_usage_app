import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackless_repository/trackless_repository.dart';
import 'package:trackless_usage_app/edit_trackless/view/edit_trackless_page.dart';
import 'package:trackless_usage_app/l10n/l10n.dart';
import 'package:trackless_usage_app/trackless_overview/bloc/trackless_overview_bloc.dart';
import 'package:trackless_usage_app/trackless_overview/widgets/trackless_list_tile.dart';

class TracklessOverviewPage extends StatelessWidget {
  const TracklessOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TracklessOverviewBloc(
        tracklessRepository: context.read<TracklessRepository>(),
      )..add(const TracklessOverviewSubscriptionRequested()),
      child: const TracklessOverviewView(),
    );
  }
}

class TracklessOverviewView extends StatelessWidget {
  const TracklessOverviewView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'floating_action_button',
        onPressed: () => Navigator.of(context).push(EditTracklessPage.route()),
        child: const Icon(Icons.add),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TracklessOverviewBloc, TracklessOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TracklessOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(l10n.errorSnackBar)));
              }
            },
          ),
          BlocListener<TracklessOverviewBloc, TracklessOverviewState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTrackless != current.lastDeletedTrackless &&
                current.lastDeletedTrackless != null,
            listener: (context, state) {
              final lastDeletedTrackless = state.lastDeletedTrackless!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      '${lastDeletedTrackless.name}|'
                      '${lastDeletedTrackless.date}',
                    ),
                    action: SnackBarAction(
                      label: l10n.undoSnackBar,
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        const event = TracklessOverviewUndoDeletionRequested();
                        context.read<TracklessOverviewBloc>().add(event);
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<TracklessOverviewBloc, TracklessOverviewState>(
          builder: (context, state) {
            if (state.trackless.isEmpty) {
              switch (state.status) {
                case TracklessOverviewStatus.failure:
                case TracklessOverviewStatus.initial:
                case TracklessOverviewStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case TracklessOverviewStatus.success:
                  final style = Theme.of(context).textTheme.headline6;
                  return Center(
                    child: Text(l10n.emptyTracklessList, style: style),
                  );
              }
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text(l10n.tracklessOverviewAppBarTitle),
                  actions: [
                    IconButton(
                      onPressed: () {
                        const event = TracklessOverviewUndoExportRequested();
                        context.read<TracklessOverviewBloc>().add(event);
                      },
                      icon: const Icon(Icons.share),
                    )
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final trackless = state.trackless[index];
                      return TracklessListTile(
                        trackless: trackless,
                        onDismissed: (_) {
                          final event = TracklessOverviewTracklessDeleted(
                            trackless,
                          );
                          context.read<TracklessOverviewBloc>().add(event);
                        },
                        onTap: () => Navigator.of(context).push(
                          EditTracklessPage.route(initialTrackless: trackless),
                        ),
                      );
                    },
                    childCount: state.trackless.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
