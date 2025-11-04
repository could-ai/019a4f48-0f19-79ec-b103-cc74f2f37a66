class Phoneme {
  String symbol;
  String name;
  String type; // consonant, vowel, etc.
  String? description;

  Phoneme({
    required this.symbol,
    required this.name,
    required this.type,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'name': name,
    'type': type,
    'description': description,
  };

  factory Phoneme.fromJson(Map<String, dynamic> json) => Phoneme(
    symbol: json['symbol'],
    name: json['name'],
    type: json['type'],
    description: json['description'],
  );
}

class Word {
  String native;
  String english;
  String? pronunciation;
  String? etymology;
  List<String> categories;

  Word({
    required this.native,
    required this.english,
    this.pronunciation,
    this.etymology,
    this.categories = const [],
  });

  Map<String, dynamic> toJson() => {
    'native': native,
    'english': english,
    'pronunciation': pronunciation,
    'etymology': etymology,
    'categories': categories,
  };

  factory Word.fromJson(Map<String, dynamic> json) => Word(
    native: json['native'],
    english: json['english'],
    pronunciation: json['pronunciation'],
    etymology: json['etymology'],
    categories: List<String>.from(json['categories'] ?? []),
  );
}

class GrammarRule {
  String name;
  String description;
  String category; // morphology, syntax, etc.
  String? example;

  GrammarRule({
    required this.name,
    required this.description,
    required this.category,
    this.example,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'category': category,
    'example': example,
  };

  factory GrammarRule.fromJson(Map<String, dynamic> json) => GrammarRule(
    name: json['name'],
    description: json['description'],
    category: json['category'],
    example: json['example'],
  );
}

class Conlang {
  String name;
  String description;
  List<Phoneme> phonology;
  List<Word> vocabulary;
  List<GrammarRule> grammar;

  Conlang({
    required this.name,
    this.description = '',
    this.phonology = const [],
    this.vocabulary = const [],
    this.grammar = const [],
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'phonology': phonology.map((p) => p.toJson()).toList(),
    'vocabulary': vocabulary.map((w) => w.toJson()).toList(),
    'grammar': grammar.map((g) => g.toJson()).toList(),
  };

  factory Conlang.fromJson(Map<String, dynamic> json) => Conlang(
    name: json['name'],
    description: json['description'],
    phonology: (json['phonology'] as List?)?.map((p) => Phoneme.fromJson(p)).toList() ?? [],
    vocabulary: (json['vocabulary'] as List?)?.map((w) => Word.fromJson(w)).toList() ?? [],
    grammar: (json['grammar'] as List?)?.map((g) => GrammarRule.fromJson(g)).toList() ?? [],
  );
}
