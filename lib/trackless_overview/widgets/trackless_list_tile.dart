import 'package:flutter/material.dart';
import 'package:trackless_repository/trackless_repository.dart';

class TracklessListTile extends StatelessWidget {
  const TracklessListTile({
    Key? key,
    required this.trackless,
    this.onToggleCompleted,
    this.onDismissed,
    this.onTap,
  }) : super(key: key);

  final Trackless trackless;
  final ValueChanged<bool>? onToggleCompleted;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('todoListTile_dismissible_${trackless.uid}'),
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          'Fecha: ${trackless.date} | '
          'H-INP: ${trackless.inoperativeHours} ',
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${trackless.name} - ${trackless.code} | '
          'Observaciones: ${trackless.observations}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      ),
    );
  }
}
