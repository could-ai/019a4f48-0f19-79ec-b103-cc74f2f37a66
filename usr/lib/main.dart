import 'package:flutter/material.dart';
import 'models/conlang_models.dart';
import 'screens/home_screen.dart';
import 'screens/phonology_screen.dart';
import 'screens/vocabulary_screen.dart';
import 'screens/grammar_screen.dart';
import 'screens/word_generator_screen.dart';

void main() {
  runApp(const ConlangApp());
}

class ConlangApp extends StatefulWidget {
  const ConlangApp({super.key});

  @override
  State<ConlangApp> createState() => _ConlangAppState();
}

class _ConlangAppState extends State<ConlangApp> {
  // Shared data that will be accessible across screens
  final List<Phoneme> _phonemes = [];
  final List<Word> _vocabulary = [];
  final List<GrammarRule> _grammar = [];

  void _addPhoneme(Phoneme phoneme) {
    setState(() {
      _phonemes.add(phoneme);
    });
  }

  void _updatePhoneme(int index, Phoneme phoneme) {
    setState(() {
      _phonemes[index] = phoneme;
    });
  }

  void _deletePhoneme(int index) {
    setState(() {
      _phonemes.removeAt(index);
    });
  }

  void _addWord(Word word) {
    setState(() {
      _vocabulary.add(word);
    });
  }

  void _updateWord(int index, Word word) {
    setState(() {
      _vocabulary[index] = word;
    });
  }

  void _deleteWord(int index) {
    setState(() {
      _vocabulary.removeAt(index);
    });
  }

  void _addGrammarRule(GrammarRule rule) {
    setState(() {
      _grammar.add(rule);
    });
  }

  void _updateGrammarRule(int index, GrammarRule rule) {
    setState(() {
      _grammar[index] = rule;
    });
  }

  void _deleteGrammarRule(int index) {
    setState(() {
      _grammar.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conlang Creator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomeScreen(
        phonemes: _phonemes,
        vocabulary: _vocabulary,
        grammar: _grammar,
        onNavigateToPhonology: () => _navigateToPhonology(context),
        onNavigateToVocabulary: () => _navigateToVocabulary(context),
        onNavigateToGrammar: () => _navigateToGrammar(context),
        onNavigateToWordGenerator: () => _navigateToWordGenerator(context),
      ),
      routes: {
        '/home': (context) => HomeScreen(
              phonemes: _phonemes,
              vocabulary: _vocabulary,
              grammar: _grammar,
              onNavigateToPhonology: () => _navigateToPhonology(context),
              onNavigateToVocabulary: () => _navigateToVocabulary(context),
              onNavigateToGrammar: () => _navigateToGrammar(context),
              onNavigateToWordGenerator: () => _navigateToWordGenerator(context),
            ),
      },
    );
  }

  void _navigateToPhonology(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhonologyScreen(
          phonemes: _phonemes,
          onAddPhoneme: _addPhoneme,
          onUpdatePhoneme: _updatePhoneme,
          onDeletePhoneme: _deletePhoneme,
        ),
      ),
    );
  }

  void _navigateToVocabulary(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VocabularyScreen(
          vocabulary: _vocabulary,
          onAddWord: _addWord,
          onUpdateWord: _updateWord,
          onDeleteWord: _deleteWord,
        ),
      ),
    );
  }

  void _navigateToGrammar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GrammarScreen(
          grammar: _grammar,
          onAddRule: _addGrammarRule,
          onUpdateRule: _updateGrammarRule,
          onDeleteRule: _deleteGrammarRule,
        ),
      ),
    );
  }

  void _navigateToWordGenerator(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WordGeneratorScreen(
          phonemes: _phonemes,
          vocabulary: _vocabulary,
        ),
      ),
    );
  }
}
