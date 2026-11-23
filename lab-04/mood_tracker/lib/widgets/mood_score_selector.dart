import 'package:flutter/material.dart';

/// A set of chips for picking a mood score from 1 to 10.
///
/// Exercise 1, step 1.
class MoodScoreSelector extends StatelessWidget {
  const MoodScoreSelector({
    super.key,
    required this.selectedScore,
    required this.onChanged,
  });

  /// The selected score, or `null` when nothing is selected yet.
  final int? selectedScore;

  /// Called with the score the user tapped.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var score = 1; score <= 10; score++)
          ChoiceChip(
            label: Text('$score'),
            selected: score == selectedScore,
            onSelected: (_) => onChanged(score),
          ),
      ],
    );
  }
}
