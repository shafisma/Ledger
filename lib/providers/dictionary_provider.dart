import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
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

  Word? get currentWord => _currentWord;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Word> get history => _history;

  DictionaryProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    _history = _storageService.getRecentWords();
    notifyListeners();
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
      if (connectivityResult == ConnectivityResult.none) {
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
