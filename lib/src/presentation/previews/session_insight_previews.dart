import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../domain/value_objects/session_recording_status.dart';
import '../widgets/session_recording_bar.dart';
import '../widgets/session_source_summary.dart';

Widget _themedPreview(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Theme(
      data: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(child: child),
      ),
    ),
  );
}

@Preview(group: 'session_recording_bar', name: 'Idle', size: Size(560, 88))
Widget previewSessionRecordingBarIdle() {
  return _themedPreview(
    const SessionRecordingBar(status: SessionRecordingStatus.idle),
  );
}

@Preview(group: 'session_recording_bar', name: 'Preparing', size: Size(560, 88))
Widget previewSessionRecordingBarPreparing() {
  return _themedPreview(
    const SessionRecordingBar(status: SessionRecordingStatus.preparing),
  );
}

@Preview(group: 'session_recording_bar', name: 'Recording', size: Size(560, 88))
Widget previewSessionRecordingBarRecording() {
  return _themedPreview(
    const SessionRecordingBar(
      status: SessionRecordingStatus.recording,
      elapsed: Duration(minutes: 4, seconds: 52),
    ),
  );
}

@Preview(group: 'session_recording_bar', name: 'Paused', size: Size(560, 88))
Widget previewSessionRecordingBarPaused() {
  return _themedPreview(
    const SessionRecordingBar(
      status: SessionRecordingStatus.paused,
      elapsed: Duration(minutes: 12, seconds: 7),
    ),
  );
}

@Preview(group: 'session_recording_bar', name: 'Stopped', size: Size(560, 88))
Widget previewSessionRecordingBarStopped() {
  return _themedPreview(
    const SessionRecordingBar(status: SessionRecordingStatus.stopped),
  );
}

@Preview(
  group: 'session_source_summary',
  name: 'Window + display',
  size: Size(400, 220),
)
Widget previewSessionSourceSummaryWithWindow() {
  return _themedPreview(
    const SizedBox(
      width: 400,
      child: SessionSourceSummary(
        displayLabel: 'Built-in Retina Display',
        windowLabel: 'Google Chrome — Example',
        audioLabel: 'MacBook Pro Microphone',
      ),
    ),
  );
}

@Preview(
  group: 'session_source_summary',
  name: 'Display only (no window row)',
  size: Size(400, 180),
)
Widget previewSessionSourceSummaryDisplayOnly() {
  return _themedPreview(
    const SizedBox(
      width: 400,
      child: SessionSourceSummary(
        displayLabel: 'LG UltraFine',
        audioLabel: 'BlackHole 2ch',
      ),
    ),
  );
}

@Preview(
  group: 'session_insight_panel',
  name: 'Bar + summary — light',
  brightness: Brightness.light,
  size: Size(420, 320),
)
Widget previewSessionInsightPanelLight() {
  return _sessionInsightPanel(Brightness.light);
}

@Preview(
  group: 'session_insight_panel',
  name: 'Bar + summary — dark',
  brightness: Brightness.dark,
  size: Size(420, 320),
)
Widget previewSessionInsightPanelDark() {
  return _sessionInsightPanel(Brightness.dark);
}

Widget _sessionInsightPanel(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF1565C0),
    brightness: brightness,
  );
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Theme(
      data: ThemeData(useMaterial3: true, colorScheme: scheme),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SessionRecordingBar(
                  status: SessionRecordingStatus.recording,
                  elapsed: Duration(minutes: 1, seconds: 5),
                ),
                SizedBox(height: 16),
                SessionSourceSummary(
                  displayLabel: 'Built-in Retina Display',
                  windowLabel: 'Zoom',
                  audioLabel: 'Same as system',
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
