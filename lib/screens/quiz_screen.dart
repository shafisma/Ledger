import 'package:flutter/material.dart';
import 'package:ledger/providers/dictionary_provider.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selectedOptionIndex;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    // Load a quiz if none exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Provider.of<DictionaryProvider>(context, listen: false).dailyQuiz == null) {
        Provider.of<DictionaryProvider>(context, listen: false).generateDailyQuiz();
      }
    });
  }

  void _handleOptionTap(int index, int correctIndex) {
    if (_answered) return;
    setState(() {
      _selectedOptionIndex = index;
      _answered = true;
    });
  }

  void _loadNextQuestion() {
    setState(() {
      _selectedOptionIndex = null;
      _answered = false;
    });
    Provider.of<DictionaryProvider>(context, listen: false).generateDailyQuiz();
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<DictionaryProvider>().dailyQuiz;
    final isLoading = context.watch<DictionaryProvider>().isQuizLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daily Quiz 🧠',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading || quiz == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress / Score could go here

                  // Question Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Which word matches this definition?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          quiz.correctWord.meanings.isNotEmpty &&
                                  quiz.correctWord.meanings.first.definitions.isNotEmpty
                              ? quiz.correctWord.meanings.first.definitions.first.definition
                              : "Definition not available",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Options
                  ...List.generate(4, (index) {
                    final option = quiz.options[index];
                    Color backgroundColor = Colors.white;
                    Color borderColor = Colors.transparent;
                    Color textColor = Colors.black;

                    if (_answered) {
                      if (index == quiz.correctOptionIndex) {
                        backgroundColor = const Color(0xFFC8E6C9); // Green
                        borderColor = Colors.green;
                      } else if (index == _selectedOptionIndex) {
                        backgroundColor = const Color(0xFFFFCDD2); // Red
                        borderColor = Colors.red;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: () => _handleOptionTap(index, quiz.correctOptionIndex),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(
                              color: _answered && (index == quiz.correctOptionIndex || index == _selectedOptionIndex)
                                  ? borderColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                             boxShadow: [
                                if (!_answered)
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                          ),
                          child: Center(
                            child: Text(
                              option.toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  const Spacer(),

                  // Next Button
                  if (_answered)
                    ElevatedButton(
                      onPressed: _loadNextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Next Question',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
