/// Data model for a stitch dictionary entry.
///
/// This is a plain Dart class (not Hive-backed) because the data is static JSON
/// bundled with the app. It is loaded once into memory at app start.
class StitchEntry {
  const StitchEntry({
    required this.id,
    required this.abbreviation,
    required this.fullName,
    required this.craft,
    required this.category,
    required this.difficulty,
    required this.description,
    required this.steps,
    required this.alsoKnownAs,
    required this.usRegion,
    required this.ukRegion,
  });

  final String id;
  final String abbreviation;
  final String fullName;
  final String craft; // 'knitting' | 'crochet'
  final String category; // 'basic' | 'increase' | 'decrease' | 'cable' | 'lace' | 'special'
  final String difficulty; // 'beginner' | 'intermediate' | 'advanced'
  final String description;
  final List<String> steps;
  final List<String> alsoKnownAs;
  final bool usRegion;
  final bool ukRegion;

  /// Create from JSON map.
  factory StitchEntry.fromJson(Map<String, dynamic> json) {
    return StitchEntry(
      id: json['id'] as String,
      abbreviation: json['abbreviation'] as String,
      fullName: json['fullName'] as String,
      craft: json['craft'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      description: json['description'] as String,
      steps: (json['steps'] as List<dynamic>).cast<String>(),
      alsoKnownAs: (json['also_known_as'] as List<dynamic>).cast<String>(),
      usRegion: json['usRegion'] as bool,
      ukRegion: json['ukRegion'] as bool,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'abbreviation': abbreviation,
      'fullName': fullName,
      'craft': craft,
      'category': category,
      'difficulty': difficulty,
      'description': description,
      'steps': steps,
      'also_known_as': alsoKnownAs,
      'usRegion': usRegion,
      'ukRegion': ukRegion,
    };
  }

  /// Check if this entry matches a search query.
  bool matchesQuery(String query) {
    final lower = query.toLowerCase();
    return abbreviation.toLowerCase().contains(lower) ||
        fullName.toLowerCase().contains(lower) ||
        alsoKnownAs.any((aka) => aka.toLowerCase().contains(lower));
  }

  @override
  String toString() {
    return 'StitchEntry($abbreviation — $fullName)';
  }
}

/// Enum-like constants for craft types.
class StitchCraft {
  StitchCraft._();
  static const String knitting = 'knitting';
  static const String crochet = 'crochet';
}

/// Enum-like constants for categories.
class StitchCategory {
  StitchCategory._();
  static const String basic = 'basic';
  static const String increase = 'increase';
  static const String decrease = 'decrease';
  static const String cable = 'cable';
  static const String lace = 'lace';
  static const String special = 'special';

  static const List<String> all = <String>[
    basic,
    increase,
    decrease,
    cable,
    lace,
    special,
  ];
}

/// Enum-like constants for difficulty levels.
class StitchDifficulty {
  StitchDifficulty._();
  static const String beginner = 'beginner';
  static const String intermediate = 'intermediate';
  static const String advanced = 'advanced';
}
