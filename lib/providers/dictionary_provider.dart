import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ledger/models/quiz_question.dart';
import 'package:ledger/models/word_model.dart';
import 'package:ledger/services/dictionary_service.dart';
import 'package:ledger/services/storage_service.dart';

class DictionaryProvider with ChangeNotifier {
  final DictionaryService _dictionaryService = DictionaryService();
  final StorageService _storageService = StorageService();

  Word? _currentWord;
  bool _isLoading = false;
  String? _error;
  List<Word> _history = [];
  
  // Quiz State
  QuizQuestion? _dailyQuiz;
  bool _isQuizLoading = false;

  Word? get currentWord => _currentWord;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Word> get history => _history;
  QuizQuestion? get dailyQuiz => _dailyQuiz;
  bool get isQuizLoading => _isQuizLoading;

  DictionaryProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    _history = _storageService.getRecentWords();
    notifyListeners();
  }

  Future<void> generateDailyQuiz() async {
    _isQuizLoading = true;
    notifyListeners();

    try {
      final random = Random();
      Word targetWord;
      List<String> options = [];

      // 1. Select a Target Word (from history or common words)
      if (_history.isNotEmpty && random.nextBool()) {
        // 50% chance to review a word from history
        targetWord = _history[random.nextInt(_history.length)];
      } else {
        // Fetch a random common word
        final wordString = DictionaryService.commonWords[random.nextInt(DictionaryService.commonWords.length)];
        final results = await _dictionaryService.getWordDefinition(wordString);
        if (results.isEmpty) throw Exception("Could not fetch quiz word");
        targetWord = results.first;
      }

      // 2. Generate Distractors (Words that are NOT the target)
      // We will just use the strings from commonWords as distractors to save API calls
      // In a real app, you'd want distractors to be similar or have real definitions loaded
      while (options.length < 3) {
        final distractor = DictionaryService.commonWords[random.nextInt(DictionaryService.commonWords.length)];
        if (distractor != targetWord.word && !options.contains(distractor)) {
          options.add(distractor);
        }
      }

      // 3. Insert Correct Answer
      final correctIndex = random.nextInt(4);
      options.insert(correctIndex, targetWord.word);

      _dailyQuiz = QuizQuestion(
        correctWord: targetWord,
        options: options,
        correctOptionIndex: correctIndex,
      );

    } catch (e) {
      debugPrint("Quiz generation failed: $e");
    } finally {
      _isQuizLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchWord(String word) async {
    if (word.trim().isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // First check local storage (optional, or maybe we want fresh data always + update local)
      // For now, let's try to fetch fresh data.
      
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
         // Offline, try local storage
         final localWord = _storageService.getWord(word);
         if (localWord != null) {
           _currentWord = localWord;
         } else {
           _error = "No internet connection and word not found locally.";
         }
      } else {
        // Online
        final words = await _dictionaryService.getWordDefinition(word);
        if (words.isNotEmpty) {
          _currentWord = words.first; // Taking the first match
          
          // Get Image
          try {
             // In a real implementation we would fetch the image and construct a new Word object 
             // with the imageUrl populated.
             final imageUrl = await _dictionaryService.getWordImage(word);
              if (imageUrl != null) {
                 // Create a copy with the image
                 _currentWord = Word(
                    word: _currentWord!.word,
                    phonetic: _currentWord!.phonetic,
                    meanings: _currentWord!.meanings,
                    sourceUrls: _currentWord!.sourceUrls,
                    imageUrl: imageUrl,
                    lastReviewDate: DateTime.now(),
                 );
              }
          } catch (e) {
            debugPrint("Image fetch failed: $e");
          }

          // Save to local storage
          await _storageService.saveWord(_currentWord!);
          await _loadHistory();
        } else {
          _error = "Word not found.";
        }
      }

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCurrentWord() {
    _currentWord = null;
    _error = null;
    notifyListeners();
  }
}
