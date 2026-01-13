import 'package:hive/hive.dart';

part 'word_model.g.dart';

@HiveType(typeId: 0)
class Word {
  @HiveField(0)
  final String word;

  @HiveField(1)
  final String? phonetic;

  @HiveField(2)
  final List<Meaning> meanings;

  @HiveField(3)
  final List<String> sourceUrls;
  
  // For caching images
  @HiveField(4)
  final String? imageUrl;

  // Add a timestamp for history/SRS
  @HiveField(5)
  final DateTime? lastReviewDate;

  @HiveField(6)
  final int? reviewInterval;

  Word({
    required this.word,
    this.phonetic,
    required this.meanings,
    this.sourceUrls = const [],
    this.imageUrl,
    this.lastReviewDate,
    this.reviewInterval,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'] ?? '',
      phonetic: json['phonetic'],
      meanings: (json['meanings'] as List<dynamic>?)
              ?.map((e) => Meaning.fromJson(e))
              .toList() ??
          [],
      sourceUrls: (json['sourceUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

@HiveType(typeId: 1)
class Meaning {
  @HiveField(0)
  final String partOfSpeech;

  @HiveField(1)
  final List<Definition> definitions;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'] ?? '',
      definitions: (json['definitions'] as List<dynamic>?)
              ?.map((e) => Definition.fromJson(e))
              .toList() ??
          [],
    );
  }
}

@HiveType(typeId: 2)
class Definition {
  @HiveField(0)
  final String definition;

  @HiveField(1)
  final String? example;

  @HiveField(2)
  final List<String> synonyms;

  @HiveField(3)
  final List<String> antonyms;

  Definition({
    required this.definition,
    this.example,
    this.synonyms = const [],
    this.antonyms = const [],
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'] ?? '',
      example: json['example'],
      synonyms: (json['synonyms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      antonyms: (json['antonyms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
