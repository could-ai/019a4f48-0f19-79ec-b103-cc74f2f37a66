import 'package:flutter/material.dart';
import '../models/conlang_models.dart';

class HomeScreen extends StatelessWidget {
  final List<Phoneme> phonemes;
  final List<Word> vocabulary;
  final List<GrammarRule> grammar;
  final VoidCallback onNavigateToPhonology;
  final VoidCallback onNavigateToVocabulary;
  final VoidCallback onNavigateToGrammar;
  final VoidCallback onNavigateToWordGenerator;

  const HomeScreen({
    super.key,
    required this.phonemes,
    required this.vocabulary,
    required this.grammar,
    required this.onNavigateToPhonology,
    required this.onNavigateToVocabulary,
    required this.onNavigateToGrammar,
    required this.onNavigateToWordGenerator,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conlang Creator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showStats(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Conlang Creator!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${phonemes.length} phonemes • ${vocabulary.length} words • ${grammar.length} rules',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            const Text(
              'Design and create your own constructed language with these tools:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    'Phonology',
                    'Define sounds and phonemes',
                    Icons.volume_up,
                    phonemes.length,
                    onNavigateToPhonology,
                  ),
                  _buildFeatureCard(
                    context,
                    'Vocabulary',
                    'Create and manage words',
                    Icons.book,
                    vocabulary.length,
                    onNavigateToVocabulary,
                  ),
                  _buildFeatureCard(
                    context,
                    'Grammar',
                    'Define grammar rules',
                    Icons.rule,
                    grammar.length,
                    onNavigateToGrammar,
                  ),
                  _buildFeatureCard(
                    context,
                    'Word Generator',
                    'Generate new words',
                    Icons.shuffle,
                    null,
                    onNavigateToWordGenerator,
                  ),
                  _buildFeatureCard(
                    context,
                    'Export',
                    'Export your conlang',
                    Icons.download,
                    null,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Export feature coming soon!')),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    'Settings',
                    'App preferences',
                    Icons.settings,
                    null,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStats(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conlang Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phonemes: ${phonemes.length}'),
            Text('Consonants: ${phonemes.where((p) => p.type == 'consonant').length}'),
            Text('Vowels: ${phonemes.where((p) => p.type == 'vowel' || p.type == 'diphthong').length}'),
            const SizedBox(height: 16),
            Text('Vocabulary: ${vocabulary.length} words'),
            Text('Grammar Rules: ${grammar.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    int? count,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  if (count != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
