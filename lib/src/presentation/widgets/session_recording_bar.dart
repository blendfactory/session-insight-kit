import 'package:flutter/material.dart';

import '../../domain/value_objects/session_recording_status.dart';

/// macOS-oriented bar: recording state, elapsed time, and primary actions.
///
/// Callbacks are optional so previews and passive demos can omit handlers.
class SessionRecordingBar extends StatelessWidget {
  const SessionRecordingBar({
    super.key,
    required this.status,
    this.elapsed,
    this.onStart,
    this.onStop,
    this.onPause,
    this.onResume,
  });

  final SessionRecordingStatus status;
  final Duration? elapsed;

  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onPause;
  final VoidCallback? onResume;

  static String _formatElapsed(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:$m:$s';
    }
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final showTimer =
        (status == SessionRecordingStatus.recording ||
            status == SessionRecordingStatus.paused) &&
        elapsed != null;

    return Material(
      color: cs.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            _StatusLeading(status: status, colorScheme: cs),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _statusTitle(status),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showTimer) ...[
              const SizedBox(width: 12),
              Text(
                _formatElapsed(elapsed!),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                  letterSpacing: 0.5,
                ),
              ),
            ],
            const SizedBox(width: 12),
            _Actions(
              status: status,
              onStart: onStart,
              onStop: onStop,
              onPause: onPause,
              onResume: onResume,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusLeading extends StatelessWidget {
  const _StatusLeading({required this.status, required this.colorScheme});

  final SessionRecordingStatus status;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case SessionRecordingStatus.preparing:
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        );
      case SessionRecordingStatus.recording:
        return Icon(
          Icons.fiber_manual_record,
          size: 20,
          color: colorScheme.error,
          semanticLabel: 'Recording',
        );
      case SessionRecordingStatus.paused:
        return Icon(
          Icons.pause_circle_filled,
          size: 22,
          color: colorScheme.tertiary,
          semanticLabel: 'Paused',
        );
      case SessionRecordingStatus.idle:
      case SessionRecordingStatus.stopped:
        return Icon(
          Icons.adjust,
          size: 20,
          color: colorScheme.outline,
          semanticLabel: 'Not recording',
        );
    }
  }
}

String _statusTitle(SessionRecordingStatus status) {
  switch (status) {
    case SessionRecordingStatus.idle:
      return 'Ready to record';
    case SessionRecordingStatus.preparing:
      return 'Starting…';
    case SessionRecordingStatus.recording:
      return 'Recording';
    case SessionRecordingStatus.paused:
      return 'Paused';
    case SessionRecordingStatus.stopped:
      return 'Session stopped';
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.status,
    this.onStart,
    this.onStop,
    this.onPause,
    this.onResume,
  });

  final SessionRecordingStatus status;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onPause;
  final VoidCallback? onResume;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case SessionRecordingStatus.idle:
      case SessionRecordingStatus.stopped:
        return FilledButton.tonalIcon(
          onPressed: onStart,
          icon: const Icon(Icons.fiber_manual_record, size: 18),
          label: const Text('Start'),
        );
      case SessionRecordingStatus.preparing:
        return FilledButton.tonal(
          onPressed: null,
          child: const Text('Please wait'),
        );
      case SessionRecordingStatus.recording:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: onPause, child: const Text('Pause')),
            const SizedBox(width: 4),
            FilledButton(onPressed: onStop, child: const Text('Stop')),
          ],
        );
      case SessionRecordingStatus.paused:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: onResume, child: const Text('Resume')),
            const SizedBox(width: 4),
            FilledButton(onPressed: onStop, child: const Text('Stop')),
          ],
        );
    }
  }
}
