import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackless_repository/trackless_repository.dart';

import 'package:trackless_usage_app/edit_trackless/bloc/edit_trackless_bloc.dart';
import 'package:trackless_usage_app/l10n/l10n.dart';

class EditTracklessPage extends StatelessWidget {
  const EditTracklessPage({Key? key}) : super(key: key);

  static Route<void> route({Trackless? initialTrackless}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditTracklessBloc(
          tracklessRepository: context.read<TracklessRepository>(),
          initialTrackless: initialTrackless,
        ),
        child: const EditTracklessPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTracklessBloc, EditTracklessState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditTracklessStatus.success,
      listener: (context, _) => Navigator.of(context).pop(),
      child: const EditTracklessView(),
    );
  }
}

class EditTracklessView extends StatelessWidget {
  const EditTracklessView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final status = context.select(
      (EditTracklessBloc bloc) => bloc.state.status,
    );
    final isNewTrackless = context.select(
      (EditTracklessBloc bloc) => bloc.state.isNewTrackless,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isNewTrackless ? l10n.addAppBar : l10n.editAppBar),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'floating_action_button',
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context.read<EditTracklessBloc>().add(
                  const EditTracklessSubmitted(),
                ),
        child: status.isLoadingOrSuccess
            ? const CircularProgressIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            Spacer(),
            _NameField(),
            Spacer(),
            _CodeField(),
            Spacer(),
            _HourFields(),
            Spacer(),
            _ObservationsField(),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

class _HourFields extends StatelessWidget {
  const _HourFields({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditTracklessBloc>().state;
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _HourPicker(
          label: l10n.editTracklessInoperativeLabel,
          hour: state.inoperativeHour,
          onTap: () async {
            final editTracklessBloc = context.read<EditTracklessBloc>();
            final value = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (value == null) return;
            final event = EditTracklessInoperativeHourChanged(
              '${value.hour}:${value.minute}',
            );
            editTracklessBloc.add(event);
          },
        ),
        _HourPicker(
          label: l10n.editTracklessOperativeLabel,
          hour: state.operativeHour,
          onTap: () async {
            final editTracklessBloc = context.read<EditTracklessBloc>();
            final value = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (value == null) return;
            final event = EditTracklessOperativeHourChanged(
              '${value.hour}:${value.minute}',
            );
            editTracklessBloc.add(event);
          },
        ),
        _HourPicker(
          label: l10n.editTracklessInoperativeHoursLabel,
          hour: state.inoperativeHours,
        ),
      ],
    );
  }
}

class _HourPicker extends StatelessWidget {
  const _HourPicker({
    Key? key,
    required this.label,
    required this.hour,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.onTap,
  }) : super(key: key);

  final String label;
  final String hour;
  final BorderRadius borderRadius;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headline5;
    return Column(
      children: [
        Text(label),
        InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: Colors.grey),
            ),
            height: 50,
            width: 100,
            child: Center(
              child: Text(hour, style: style),
            ),
          ),
        ),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTracklessBloc>().state;
    final hintText = state.initialTrackless?.name ?? '';

    return DropdownButtonFormField<String>(
      key: const Key('editTracklessView_name_textFormField'),
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editTracklessNameLabel,
        hintText: hintText,
      ),
      value: state.name,
      items: Trackless.names
          .map(
            (name) => DropdownMenuItem<String>(
              value: name,
              child: Text(name),
            ),
          )
          .toList(),
      onChanged: (value) {
        final event = EditTracklessNameChanged(value!);
        context.read<EditTracklessBloc>().add(event);
      },
    );
  }
}

class _CodeField extends StatelessWidget {
  const _CodeField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTracklessBloc>().state;
    final hintText = state.initialTrackless?.code ?? '';

    return TextFormField(
      key: const Key('editTracklessView_code_textFormField'),
      initialValue: state.code,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editTracklessCodeLabel, //code
        hintText: hintText,
      ),
      onChanged: (value) {
        final event = EditTracklessCodeChanged(value);
        context.read<EditTracklessBloc>().add(event);
      },
    );
  }
}

class _ObservationsField extends StatelessWidget {
  const _ObservationsField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTracklessBloc>().state;
    final hintText = state.initialTrackless?.observations ?? '';

    return TextFormField(
      key: const Key('editTracklessView_observations_textFormField'),
      initialValue: state.observations,
      maxLines: 4,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editTracklessObservationsLabel,
        hintText: hintText,
      ),
      onChanged: (value) {
        final event = EditTracklessObservationsChanged(value);
        context.read<EditTracklessBloc>().add(event);
      },
    );
  }
}
