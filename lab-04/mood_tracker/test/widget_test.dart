import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/data/sample_entries.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/models/mood_entry.dart';
import 'package:mood_tracker/widgets/mood_card.dart';

// Covers Exercises 1-2 (saving an entry) and Exercise 3 (validation).
// Run it with: flutter test

/// Renders the app in a window tall enough for every card to be built.
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MoodTrackerApp());
}

Finder get saveButton => find.widgetWithText(FilledButton, 'Save entry');

void main() {
  // Updated for the Exercise 3 requirement: Save is always enabled and
  // explains the problem instead of being silently disabled.
  testWidgets('saving without a score shows a message and adds nothing',
      (tester) async {
    await pumpApp(tester);

    expect(tester.widget<FilledButton>(saveButton).onPressed, isNotNull);

    await tester.tap(saveButton);
    await tester.pump();

    expect(find.text('Choose a score from 1 to 10'), findsOneWidget);
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length));
  });

  testWidgets('saving an entry puts it at the top of the history',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, '3'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Rainy walk home');
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(
      find.descendant(
        of: find.byType(MoodCard).first,
        matching: find.text('Rainy walk home'),
      ),
      findsOneWidget,
    );
    expect(find.text('Choose a score from 1 to 10'), findsNothing);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty);
  });

  testWidgets('a note of exactly maxNoteLength characters is saved',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, '5'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'a' * maxNoteLength);
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(find.textContaining('too long'), findsNothing);
  });

  testWidgets('a note over maxNoteLength shows an error and adds nothing',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, '5'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'a' * (maxNoteLength + 1));
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.textContaining('limit is $maxNoteLength'), findsOneWidget);
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length));
    // The typed note is kept so the user can shorten it.
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text.length,
      maxNoteLength + 1,
    );
  });

  testWidgets('errors disappear once the problem is fixed', (tester) async {
    await pumpApp(tester);

    await tester.tap(saveButton);
    await tester.pump();
    expect(find.text('Choose a score from 1 to 10'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, '7'));
    await tester.pump();
    expect(find.text('Choose a score from 1 to 10'), findsNothing);

    await tester.enterText(find.byType(TextField), 'a' * (maxNoteLength + 1));
    await tester.tap(saveButton);
    await tester.pump();
    expect(find.textContaining('too long'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'short note');
    await tester.pump();
    expect(find.textContaining('too long'), findsNothing);

    await tester.tap(saveButton);
    await tester.pump();
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
  });

  testWidgets('a note is optional', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, '8'));
    await tester.pump();
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
  });
}
