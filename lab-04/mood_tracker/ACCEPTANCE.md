# Acceptance criteria: mood entry validation

Requirement: instead of silently disabling **Save entry**, the form tells the
user what is wrong. Notes may be at most 2000 characters (`maxNoteLength`).

1. **No score selected (must fail).** Given no score is selected, when I tap
   **Save entry**, then the message "Choose a score from 1 to 10" is shown in
   the form and nothing is added to the history.
2. **Valid entry.** Given I selected score 3 and typed "Rainy walk home", when
   I tap **Save entry**, then the entry appears at the top of the history, no
   error is shown, and the form is cleared.
3. **Note at the limit (boundary, passes).** Given I selected a score and typed
   a note of exactly 2000 characters, when I tap **Save entry**, then the entry
   is added to the history and no error is shown.
4. **Note over the limit (boundary, must fail).** Given I selected a score and
   typed a note of 2001 characters, when I tap **Save entry**, then an error
   mentioning the 2000-character limit is shown under the note field, nothing
   is added to the history, and the note text I typed is kept.
5. **Errors go away.** Given an error is shown, when I fix the problem (choose a
   score, or shorten the note) and tap **Save entry**, then the error
   disappears and the entry is saved.
6. **Optional note.** Given I selected a score and left the note empty, when I
   tap **Save entry**, then the entry is saved without a note.
