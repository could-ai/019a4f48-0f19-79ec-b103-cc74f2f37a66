import 'package:flutter/material.dart';
import '../models/conlang_models.dart';

class PhonologyScreen extends StatefulWidget {
  final List<Phoneme> phonemes;
  final Function(Phoneme) onAddPhoneme;
  final Function(int, Phoneme) onUpdatePhoneme;
  final Function(int) onDeletePhoneme;

  const PhonologyScreen({
    super.key,
    required this.phonemes,
    required this.onAddPhoneme,
    required this.onUpdatePhoneme,
    required this.onDeletePhoneme,
  });

  @override
  State<PhonologyScreen> createState() => _PhonologyScreenState();
}

class _PhonologyScreenState extends State<PhonologyScreen> {
  void _addPhoneme() {
    showDialog(
      context: context,
      builder: (context) => PhonemeDialog(
        onSave: widget.onAddPhoneme,
      ),
    );
  }

  void _editPhoneme(int index) {
    showDialog(
      context: context,
      builder: (context) => PhonemeDialog(
        phoneme: widget.phonemes[index],
        onSave: (phoneme) => widget.onUpdatePhoneme(index, phoneme),
      ),
    );
  }

  void _deletePhoneme(int index) {
    widget.onDeletePhoneme(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phonology'),
      ),
      body: widget.phonemes.isEmpty
          ? const Center(
              child: Text('No phonemes defined yet. Tap + to add some!'),
            )
          : ListView.builder(
              itemCount: widget.phonemes.length,
              itemBuilder: (context, index) {
                final phoneme = widget.phonemes[index];
                return ListTile(
                  title: Text('${phoneme.symbol} - ${phoneme.name}'),
                  subtitle: Text('${phoneme.type}${phoneme.description != null ? ' • ${phoneme.description}' : ''}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editPhoneme(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deletePhoneme(index),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPhoneme,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PhonemeDialog extends StatefulWidget {
  final Phoneme? phoneme;
  final Function(Phoneme) onSave;

  const PhonemeDialog({super.key, this.phoneme, required this.onSave});

  @override
  State<PhonemeDialog> createState() => _PhonemeDialogState();
}

class _PhonemeDialogState extends State<PhonemeDialog> {
  late TextEditingController _symbolController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _type = 'consonant';

  @override
  void initState() {
    super.initState();
    _symbolController = TextEditingController(text: widget.phoneme?.symbol ?? '');
    _nameController = TextEditingController(text: widget.phoneme?.name ?? '');
    _descriptionController = TextEditingController(text: widget.phoneme?.description ?? '');
    _type = widget.phoneme?.type ?? 'consonant';
  }

  @override
  void dispose() {
    _symbolController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_symbolController.text.isEmpty || _nameController.text.isEmpty) return;

    final phoneme = Phoneme(
      symbol: _symbolController.text,
      name: _nameController.text,
      type: _type,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
    );

    widget.onSave(phoneme);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.phoneme == null ? 'Add Phoneme' : 'Edit Phoneme'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _symbolController,
              decoration: const InputDecoration(labelText: 'Symbol'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Type'),
              items: const [
                DropdownMenuItem(value: 'consonant', child: Text('Consonant')),
                DropdownMenuItem(value: 'vowel', child: Text('Vowel')),
                DropdownMenuItem(value: 'diphthong', child: Text('Diphthong')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description (optional)'),
              maxLines: 3,
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
