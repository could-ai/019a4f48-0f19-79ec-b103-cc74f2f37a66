import 'package:flutter/material.dart';
import '../models/conlang_models.dart';

class GrammarScreen extends StatefulWidget {
  final List<GrammarRule> grammar;
  final Function(GrammarRule) onAddRule;
  final Function(int, GrammarRule) onUpdateRule;
  final Function(int) onDeleteRule;

  const GrammarScreen({
    super.key,
    required this.grammar,
    required this.onAddRule,
    required this.onUpdateRule,
    required this.onDeleteRule,
  });

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  void _addRule() {
    showDialog(
      context: context,
      builder: (context) => GrammarRuleDialog(
        onSave: widget.onAddRule,
      ),
    );
  }

  void _editRule(int index) {
    showDialog(
      context: context,
      builder: (context) => GrammarRuleDialog(
        rule: widget.grammar[index],
        onSave: (rule) => widget.onUpdateRule(index, rule),
      ),
    );
  }

  void _deleteRule(int index) {
    widget.onDeleteRule(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grammar'),
      ),
      body: widget.grammar.isEmpty
          ? const Center(
              child: Text('No grammar rules defined yet. Tap + to add some!'),
            )
          : ListView.builder(
              itemCount: widget.grammar.length,
              itemBuilder: (context, index) {
                final rule = widget.grammar[index];
                return ListTile(
                  title: Text(rule.name),
                  subtitle: Text('${rule.category} • ${rule.description}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editRule(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteRule(index),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (rule.example != null) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(rule.name),
                          content: Text('Example: ${rule.example}'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRule,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class GrammarRuleDialog extends StatefulWidget {
  final GrammarRule? rule;
  final Function(GrammarRule) onSave;

  const GrammarRuleDialog({super.key, this.rule, required this.onSave});

  @override
  State<GrammarRuleDialog> createState() => _GrammarRuleDialogState();
}

class _GrammarRuleDialogState extends State<GrammarRuleDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _exampleController;
  String _category = 'morphology';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.rule?.name ?? '');
    _descriptionController = TextEditingController(text: widget.rule?.description ?? '');
    _exampleController = TextEditingController(text: widget.rule?.example ?? '');
    _category = widget.rule?.category ?? 'morphology';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _exampleController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) return;

    final rule = GrammarRule(
      name: _nameController.text,
      description: _descriptionController.text,
      category: _category,
      example: _exampleController.text.isEmpty ? null : _exampleController.text,
    );

    widget.onSave(rule);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.rule == null ? 'Add Grammar Rule' : 'Edit Grammar Rule'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Rule name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(value: 'morphology', child: Text('Morphology')),
                DropdownMenuItem(value: 'syntax', child: Text('Syntax')),
                DropdownMenuItem(value: 'phonology', child: Text('Phonology')),
                DropdownMenuItem(value: 'semantics', child: Text('Semantics')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
            ),
            TextField(
              controller: _exampleController,
              decoration: const InputDecoration(labelText: 'Example (optional)'),
              maxLines: 2,
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
