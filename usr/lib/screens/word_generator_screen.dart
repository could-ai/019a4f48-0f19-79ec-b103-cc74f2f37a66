import 'package:flutter/material.dart';
import 'dart:math';
import '../models/conlang_models.dart';

class WordGeneratorScreen extends StatefulWidget {
  final List<Phoneme> phonemes;
  final List<Word> vocabulary;

  const WordGeneratorScreen({
    super.key,
    required this.phonemes,
    required this.vocabulary,
  });

  @override
  State<WordGeneratorScreen> createState() => _WordGeneratorScreenState();
}

class _WordGeneratorScreenState extends State<WordGeneratorScreen> {
  final Random _random = Random();
  String _generatedWord = '';
  int _syllables = 2;
  String _wordType = 'noun';

  List<Phoneme> get _consonants => widget.phonemes.where((p) => p.type == 'consonant').toList();
  List<Phoneme> get _vowels => widget.phonemes.where((p) => p.type == 'vowel' || p.type == 'diphthong').toList();

  void _generateWord() {
    if (_consonants.isEmpty || _vowels.isEmpty) {
      setState(() {
        _generatedWord = 'Please define consonants and vowels in Phonology first';
      });
      return;
    }

    String word = '';
    for (int i = 0; i < _syllables; i++) {
      // Simple syllable structure: C + V + (C)
      if (_consonants.isNotEmpty) {
        word += _consonants[_random.nextInt(_consonants.length)].symbol;
      }
      if (_vowels.isNotEmpty) {
        word += _vowels[_random.nextInt(_vowels.length)].symbol;
      }
      // Optional final consonant
      if (_random.nextBool() && _consonants.isNotEmpty) {
        word += _consonants[_random.nextInt(_consonants.length)].symbol;
      }
    }

    setState(() {
      _generatedWord = word;
    });
  }

  void _saveWord() {
    if (_generatedWord.isEmpty || _generatedWord.contains('Please define')) return;

    showDialog(
      context: context,
      builder: (context) => WordDialog(
        initialNative: _generatedWord,
        initialCategory: _wordType,
        onSave: (word) {
          // In a real app, this would save to vocabulary
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Word "${word.native}" saved to vocabulary!')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generate new words for your conlang',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Syllables:'),
                    Slider(
                      value: _syllables.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _syllables.toString(),
                      onChanged: (value) {
                        setState(() {
                          _syllables = value.toInt();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _wordType,
                      decoration: const InputDecoration(labelText: 'Word Type'),
                      items: const [
                        DropdownMenuItem(value: 'noun', child: Text('Noun')),
                        DropdownMenuItem(value: 'verb', child: Text('Verb')),
                        DropdownMenuItem(value: 'adjective', child: Text('Adjective')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _wordType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _generateWord,
                      icon: const Icon(Icons.shuffle),
                      label: const Text('Generate Word'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (_generatedWord.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Generated Word:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _generatedWord,
                        style: const TextStyle(fontSize: 24, fontFamily: 'monospace'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _generateWord,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Regenerate'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: _saveWord,
                            icon: const Icon(Icons.save),
                            label: const Text('Save to Vocabulary'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class WordDialog extends StatefulWidget {
  final String initialNative;
  final String initialCategory;
  final Function(Word) onSave;

  const WordDialog({
    super.key,
    required this.initialNative,
    required this.initialCategory,
    required this.onSave,
  });

  @override
  State<WordDialog> createState() => _WordDialogState();
}

class _WordDialogState extends State<WordDialog> {
  late TextEditingController _nativeController;
  late TextEditingController _englishController;

  @override
  void initState() {
    super.initState();
    _nativeController = TextEditingController(text: widget.initialNative);
    _englishController = TextEditingController();
  }

  @override
  void dispose() {
    _nativeController.dispose();
    _englishController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nativeController.text.isEmpty || _englishController.text.isEmpty) return;

    final word = Word(
      native: _nativeController.text,
      english: _englishController.text,
      categories: [widget.initialCategory],
    );

    widget.onSave(word);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save Word to Vocabulary'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nativeController,
            decoration: const InputDecoration(labelText: 'Native word'),
          ),
          TextField(
            controller: _englishController,
            decoration: const InputDecoration(labelText: 'English translation'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
