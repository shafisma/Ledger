import 'package:ledger/models/word_model.dart';

class QuizQuestion {
  final Word correctWord;
  final List<String> options; // 3 distractors + 1 correct word
  final int correctOptionIndex;

  QuizQuestion({
    required this.correctWord,
    required this.options,
    required this.correctOptionIndex,
  });
}
