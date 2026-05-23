import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:session_insight_kit/session_insight_kit.dart';

void main() {
  testWidgets('SessionRecordingBar shows Recording when active', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SessionRecordingBar(
            status: SessionRecordingStatus.recording,
            elapsed: Duration(seconds: 30),
          ),
        ),
      ),
    );

    expect(find.text('Recording'), findsOneWidget);
    expect(find.text('00:30'), findsOneWidget);
  });

  testWidgets('SessionSourceSummary lists display and audio', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SessionSourceSummary(
            displayLabel: 'Test Display',
            audioLabel: 'Test Mic',
          ),
        ),
      ),
    );

    expect(find.text('Test Display'), findsOneWidget);
    expect(find.text('Test Mic'), findsOneWidget);
    expect(find.text('Window'), findsNothing);
  });
}
