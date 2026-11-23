import 'package:flutter/material.dart';

import '../models/mood_entry.dart';
import 'mood_score_selector.dart';

/// A form for recording a new mood entry.
///
/// Exercise 1, step 3, and Exercise 2, steps 1-3. Validation: Exercise 3.
class MoodEntryForm extends StatefulWidget {
  const MoodEntryForm({super.key, required this.onSubmit});

  /// Called with the new entry when the user saves it.
  final ValueChanged<MoodEntry> onSubmit;

  @override
  State<MoodEntryForm> createState() => _MoodEntryFormState();
}

class _MoodEntryFormState extends State<MoodEntryForm> {
  int? _score;
  String? _scoreError;
  String? _noteError;

  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    final score = _score;
    final note = _noteController.text.trim();

    final scoreError = score == null ? 'Choose a score from 1 to 10' : null;
    final noteError = note.length > maxNoteLength
        ? 'Note is too long (${note.length} characters). '
            'The limit is $maxNoteLength.'
        : null;

    if (scoreError != null || noteError != null) {
      setState(() {
        _scoreError = scoreError;
        _noteError = noteError;
      });
      return;
    }

    widget.onSubmit(
      MoodEntry(
        score: score!,
        note: note.isEmpty ? null : note,
        createdAt: DateTime.now(),
      ),
    );
    setState(() {
      _score = null;
      _scoreError = null;
      _noteError = null;
    });
    _noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How are you feeling?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            MoodScoreSelector(
              selectedScore: _score,
              onChanged: (score) {
                setState(() {
                  _score = score;
                  _scoreError = null;
                });
              },
            ),
            if (_scoreError != null) ...[
              const SizedBox(height: 8),
              Text(
                _scoreError!,
                style: TextStyle(color: colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Note (optional)',
                errorText: _noteError,
                errorMaxLines: 3,
              ),
              onChanged: (_) {
                if (_noteError != null) {
                  setState(() {
                    _noteError = null;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _save,
              child: const Text('Save entry'),
            ),
          ],
        ),
      ),
    );
  }
}
