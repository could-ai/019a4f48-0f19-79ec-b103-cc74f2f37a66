import 'package:flutter/material.dart';
import '../models/conlang_models.dart';

class VocabularyScreen extends StatefulWidget {
  final List<Word> vocabulary;
  final Function(Word) onAddWord;
  final Function(int, Word) onUpdateWord;
  final Function(int) onDeleteWord;

  const VocabularyScreen({
    super.key,
    required this.vocabulary,
    required this.onAddWord,
    required this.onUpdateWord,
    required this.onDeleteWord,
  });

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  void _addWord() {
    showDialog(
      context: context,
      builder: (context) => WordDialog(
        onSave: widget.onAddWord,
      ),
    );
  }

  void _editWord(int index) {
    showDialog(
      context: context,
      builder: (context) => WordDialog(
        word: widget.vocabulary[index],
        onSave: (word) => widget.onUpdateWord(index, word),
      ),
    );
  }

  void _deleteWord(int index) {
    widget.onDeleteWord(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary'),
      ),
      body: widget.vocabulary.isEmpty
          ? const Center(
              child: Text('No words defined yet. Tap + to add some!'),
            )
          : ListView.builder(
              itemCount: widget.vocabulary.length,
              itemBuilder: (context, index) {
                final word = widget.vocabulary[index];
                return ListTile(
                  title: Text('${word.native} - ${word.english}'),
                  subtitle: Text(word.pronunciation ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editWord(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteWord(index),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWord,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class WordDialog extends StatefulWidget {
  final Word? word;
  final Function(Word) onSave;

  const WordDialog({super.key, this.word, required this.onSave});

  @override
  State<WordDialog> createState() => _WordDialogState();
}

class _WordDialogState extends State<WordDialog> {
  late TextEditingController _nativeController;
  late TextEditingController _englishController;
  late TextEditingController _pronunciationController;
  late TextEditingController _etymologyController;
  final List<String> _categories = [];
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nativeController = TextEditingController(text: widget.word?.native ?? '');
    _englishController = TextEditingController(text: widget.word?.english ?? '');
    _pronunciationController = TextEditingController(text: widget.word?.pronunciation ?? '');
    _etymologyController = TextEditingController(text: widget.word?.etymology ?? '');
    _categories.addAll(widget.word?.categories ?? []);
  }

  @override
  void dispose() {
    _nativeController.dispose();
    _englishController.dispose();
    _pronunciationController.dispose();
    _etymologyController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _addCategory() {
    if (_categoryController.text.isNotEmpty) {
      setState(() {
        _categories.add(_categoryController.text);
        _categoryController.clear();
      });
    }
  }

  void _removeCategory(int index) {
    setState(() {
      _categories.removeAt(index);
    });
  }

  void _save() {
    if (_nativeController.text.isEmpty || _englishController.text.isEmpty) return;

    final word = Word(
      native: _nativeController.text,
      english: _englishController.text,
      pronunciation: _pronunciationController.text.isEmpty ? null : _pronunciationController.text,
      etymology: _etymologyController.text.isEmpty ? null : _etymologyController.text,
      categories: _categories,
    );

    widget.onSave(word);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.word == null ? 'Add Word' : 'Edit Word'),
      content: SingleChildScrollView(
        child: Column(
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
            TextField(
              controller: _pronunciationController,
              decoration: const InputDecoration(labelText: 'Pronunciation (optional)'),
            ),
            TextField(
              controller: _etymologyController,
              decoration: const InputDecoration(labelText: 'Etymology (optional)'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            const Text('Categories:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Add category'),
                    onSubmitted: (_) => _addCategory(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCategory,
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: _categories.map((category) {
                return Chip(
                  label: Text(category),
                  onDeleted: () => _removeCategory(_categories.indexOf(category)),
                );
              }).toList(),
            ),
          ],
        ),
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
