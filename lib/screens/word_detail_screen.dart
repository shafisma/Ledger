import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ledger/providers/dictionary_provider.dart';
import 'package:provider/provider.dart';

class WordDetailScreen extends StatelessWidget {
  const WordDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final word = context.watch<DictionaryProvider>().currentWord;

    if (word == null) {
      return const Scaffold(
        body: Center(child: Text('No word selected')),
      );
    }
    
    // We'll take the first meaning for the main display, usually what's expected
    final mainMeaning = word.meanings.isNotEmpty ? word.meanings.first : null;
    final definition = mainMeaning?.definitions.isNotEmpty == true 
        ? mainMeaning!.definitions.first 
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               // Header
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '9:41',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                   Row(
                    children: [
                      const Icon(Icons.signal_cellular_alt, size: 16),
                      const SizedBox(width: 4),
                      const Icon(Icons.wifi, size: 16),
                      const SizedBox(width: 4),
                      const Icon(Icons.battery_full, size: 16),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 16),

              // Word Card
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5), // Light purple bg like design
                  borderRadius: BorderRadius.circular(24),
                  image: word.imageUrl != null 
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(word.imageUrl!),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.white.withValues(alpha: 0.85), 
                          BlendMode.lighten,
                        ),
                      ) 
                    : null,
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          word.word,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.volume_up_rounded, color: Colors.deepPurple),
                        ),
                      ],
                    ),
                    if (word.phonetic != null)
                      Text(
                        word.phonetic!,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(height: 24),
                    if (mainMeaning != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1C4E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          mainMeaning.partOfSpeech.toUpperCase(), // Capitalized like in design (e.g. Verb but capitalized)
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Definition Card
              if (definition != null)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        definition.definition,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      if (definition.example != null) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'e.g',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          definition.example!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Synonyms
              if (definition != null && definition.synonyms.isNotEmpty) ...[
                const Text(
                  'Synonyms',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                     color: const Color(0xFFE8F5E9), // Light Green
                     borderRadius: BorderRadius.circular(16)
                  ),
                  width: double.infinity,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: definition.synonyms.take(5).map((synonym) {
                      return Chip(
                        label: Text(synonym),
                        backgroundColor: const Color(0xFFC8E6C9),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

               // Antonyms
              if (definition != null && definition.antonyms.isNotEmpty) ...[
                const Text(
                  'Antonyms',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                     color: const Color(0xFFFFEBEE), // Light Pink
                     borderRadius: BorderRadius.circular(16)
                  ),
                   width: double.infinity,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: definition.antonyms.take(5).map((antonym) {
                      return Chip(
                        label: Text(antonym),
                        backgroundColor: const Color(0xFFFFCDD2),
                        side: BorderSide.none,
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
