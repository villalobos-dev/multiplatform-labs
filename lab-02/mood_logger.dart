/// Lab 2 Individual Assignment (A2) -- CLI Mood Logger (TEMPLATE)
///
/// Build a command-line mood tracking application.
/// Implement all the TODO sections below.
///
/// Run with: dart run mood_logger_template.dart
///
/// Requirements:
///   - MoodEntry class to represent a single mood log
///   - MoodLogger class to manage a collection of entries
///   - Interactive CLI with a menu loop
///
/// Do NOT use AI tools. Write all code yourself.

import 'dart:io';

// ============================================================================
// MoodEntry Class
// ============================================================================

/// Represents a single mood log entry.
///
/// Fields:
///   - DateTime createdAt  -- when the entry was created
///   - int score           -- mood score from 1 (very bad) to 10 (excellent)
///   - String? note        -- an optional short description of the mood;
///                            null when the user wrote nothing
///
/// The Flutter Mood Tracker you build from Lab 3 onwards uses the same three
/// fields, so this class carries over almost unchanged.
class MoodEntry {
  final DateTime createdAt;
  final int score;
  final String? note;

  MoodEntry(this.score, [this.note]) : createdAt = DateTime.now();

  /// Returns a formatted string representation of this entry.
  /// Format: "[YYYY-MM-DD HH:MM] Score: <score>/10 - <note>"
  /// When there is no note, show "(no note)" in its place.
  @override
  String toString() {
    String two(int n) => n.toString().padLeft(2, '0');
    final date = '${createdAt.year}-${two(createdAt.month)}-${two(createdAt.day)}';
    final time = '${two(createdAt.hour)}:${two(createdAt.minute)}';
    return '[$date $time] Score: $score/10 - ${note ?? '(no note)'}';
  }
}

// ============================================================================
// MoodLogger Class
// ============================================================================

/// Manages a collection of MoodEntry objects.
class MoodLogger {
  final List<MoodEntry> _entries = [];

  /// Adds a new mood entry with the given score and optional note.
  ///
  /// Validates that score is between 1 and 10 (inclusive).
  /// If invalid, prints an error message and does NOT add the entry.
  /// A note that is empty or only spaces is stored as null.
  void addEntry(int score, String? note) {
    if (score < 1 || score > 10) {
      print('Error: score must be between 1 and 10.');
      return;
    }
    final trimmed = note?.trim();
    final cleanNote = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    _entries.add(MoodEntry(score, cleanNote));
    print('Entry added.');
  }

  /// Returns a copy of all entries.
  List<MoodEntry> getAllEntries() => List.from(_entries);

  /// Calculates and returns the average mood score.
  ///
  /// Returns null if there are no entries.
  double? getAverageScore() {
    if (_entries.isEmpty) return null;
    final total = _entries.fold<int>(0, (sum, e) => sum + e.score);
    return total / _entries.length;
  }

  /// Returns all entries with a score greater than or equal to [threshold].
  List<MoodEntry> getEntriesAbove(int threshold) =>
      _entries.where((e) => e.score >= threshold).toList();

  /// Returns the total number of entries.
  int get entryCount => _entries.length;
}

// ============================================================================
// Main -- Interactive CLI
// ============================================================================

void main() {
  final logger = MoodLogger();

  print('=== Mood Logger ===');
  print('Track your daily mood on a scale of 1-10.\n');

  bool running = true;
  while (running) {
    print('1. Add mood entry');
    print('2. View all entries');
    print('3. View average mood');
    print('4. Filter by minimum score');
    print('5. Quit');
    stdout.write('\nChoose an option: ');

    String? input = stdin.readLineSync();
    if (input == null) {
      // End of input (e.g. Ctrl+D): exit cleanly instead of looping forever.
      print('\nGoodbye!');
      break;
    }
    int? choice = int.tryParse(input.trim());

    switch (choice) {
      case 1:
        stdout.write('Mood score (1-10): ');
        final score = int.tryParse(stdin.readLineSync()?.trim() ?? '');
        if (score == null) {
          print('Error: please enter a whole number.');
          break;
        }
        stdout.write('Note (press Enter for no note): ');
        final note = stdin.readLineSync();
        logger.addEntry(score, note);
        break;
      case 2:
        final entries = logger.getAllEntries();
        if (entries.isEmpty) {
          print('No entries yet.');
        } else {
          print('All entries (${logger.entryCount}):');
          for (final entry in entries) {
            print('  $entry');
          }
        }
        break;
      case 3:
        final average = logger.getAverageScore();
        if (average == null) {
          print('No entries yet, so there is no average.');
        } else {
          print('Average mood: ${average.toStringAsFixed(1)}/10 '
              '(${logger.entryCount} entries)');
        }
        break;
      case 4:
        stdout.write('Minimum score: ');
        final threshold = int.tryParse(stdin.readLineSync()?.trim() ?? '');
        if (threshold == null) {
          print('Error: please enter a whole number.');
          break;
        }
        final filtered = logger.getEntriesAbove(threshold);
        if (filtered.isEmpty) {
          print('No entries with score >= $threshold.');
        } else {
          print('Entries with score >= $threshold:');
          for (final entry in filtered) {
            print('  $entry');
          }
        }
        break;
      case 5:
        running = false;
        print('Goodbye!');
        break;
      default:
        print('Invalid option. Please choose 1-5.');
    }
    print('');
  }
}
