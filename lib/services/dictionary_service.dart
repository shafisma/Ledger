import 'package:dio/dio.dart';
import 'package:ledger/models/word_model.dart';

class DictionaryService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

  Future<List<Word>> getWordDefinition(String word) async {
    try {
      final response = await _dio.get('$_baseUrl$word');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Word.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load word definition');
      }
    } catch (e) {
      throw Exception('Failed to load word definition: $e');
    }
  }

  // Placeholder for Unsplash Image integration
  Future<String?> getWordImage(String word) async {
    // In a real app, you would use Unsplash API here with a key.
    // final response = await _dio.get('https://api.unsplash.com/search/photos?query=$word&client_id=YOUR_ACCESS_KEY');
    // Using a placeholder service for demo purposes without authentication
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return a constructed URL that effectively works like a search
    // Note: older unsplash source urls are deprecated, but let's try a direct keyword search or return null to fall back to colors
    return 'https://loremflickr.com/320/240/$word';
  }

  // Fallback words for quiz generation when history is empty
  static const List<String> commonWords = [
    'serendipity', 'ephemeral', 'oblivion', 'longevity', 'harmony', 
    'adventure', 'resilience', 'solitude', 'nostalgia', 'wisdom',
    'curiosity', 'freedom', 'gratitude', 'happiness', 'imagination'
  ];
}
