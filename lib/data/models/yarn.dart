import 'package:flutter/foundation.dart';

/// Yarn stash entry model.
///
/// Immutable with copyWith. Stored in Hive via [YarnAdapter].
@immutable
class Yarn {
  const Yarn({
    required this.id,
    required this.brand,
    required this.colourName,
    required this.weight,
    required this.fibre,
    required this.yardagePerSkein,
    required this.metreagePerSkein,
    required this.gramsPerSkein,
    required this.skeinCount,
    required this.hexColour,
    this.notes = '',
    this.purchaseLocation,
    this.status = YarnStatus.available,
    this.linkedProjectIds = const <String>[],
    this.photoUris = const <String>[],
  });

  final String id;
  final String brand;
  final String colourName;
  final String
      weight; // lace, fingering, sport, dk, worsted, aran, bulky, superBulky
  final String fibre;
  final int yardagePerSkein;
  final int metreagePerSkein;
  final int gramsPerSkein;
  final int skeinCount;
  final String hexColour; // e.g. '#7B3F6E'
  final String notes;
  final String? purchaseLocation;
  final String status; // YarnStatus values
  final List<String> linkedProjectIds;
  final List<String> photoUris; // Local file paths to yarn photos

  /// Total yardage across all skeins.
  int get totalYardage => yardagePerSkein * skeinCount;

  /// Total metreage across all skeins.
  int get totalMetreage => metreagePerSkein * skeinCount;

  /// Total grams across all skeins.
  int get totalGrams => gramsPerSkein * skeinCount;

  Yarn copyWith({
    String? id,
    String? brand,
    String? colourName,
    String? weight,
    String? fibre,
    int? yardagePerSkein,
    int? metreagePerSkein,
    int? gramsPerSkein,
    int? skeinCount,
    String? hexColour,
    String? notes,
    String? purchaseLocation,
    String? status,
    List<String>? linkedProjectIds,
    List<String>? photoUris,
  }) {
    return Yarn(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      colourName: colourName ?? this.colourName,
      weight: weight ?? this.weight,
      fibre: fibre ?? this.fibre,
      yardagePerSkein: yardagePerSkein ?? this.yardagePerSkein,
      metreagePerSkein: metreagePerSkein ?? this.metreagePerSkein,
      gramsPerSkein: gramsPerSkein ?? this.gramsPerSkein,
      skeinCount: skeinCount ?? this.skeinCount,
      hexColour: hexColour ?? this.hexColour,
      notes: notes ?? this.notes,
      purchaseLocation: purchaseLocation == _clearSentinel
          ? null
          : (purchaseLocation ?? this.purchaseLocation),
      status: status ?? this.status,
      linkedProjectIds: linkedProjectIds ?? this.linkedProjectIds,
      photoUris: photoUris ?? this.photoUris,
    );
  }

  static const String _clearSentinel = '\x00CLEAR\x00';

  Yarn clearPurchaseLocation() => copyWith(purchaseLocation: _clearSentinel);

  /// Link to a project.
  Yarn linkToProject(String projectId) {
    if (linkedProjectIds.contains(projectId)) return this;
    return copyWith(
      linkedProjectIds: List<String>.from(linkedProjectIds)..add(projectId),
      status: YarnStatus.inUse,
    );
  }

  /// Unlink from a project.
  Yarn unlinkFromProject(String projectId) {
    final updated = List<String>.from(linkedProjectIds)..remove(projectId);
    return copyWith(
      linkedProjectIds: updated,
      status: updated.isEmpty ? YarnStatus.available : YarnStatus.inUse,
    );
  }

  @override
  String toString() {
    return 'Yarn($brand $colourName — $weight — $skeinCount skeins)';
  }
}

/// Yarn status constants.
class YarnStatus {
  YarnStatus._();
  static const String available = 'available';
  static const String inUse = 'inUse';
  static const String usedUp = 'usedUp';

  static const List<String> all = <String>[
    available,
    inUse,
    usedUp,
  ];
}

/// Yarn weight constants.
class YarnWeight {
  YarnWeight._();
  static const String lace = 'lace';
  static const String fingering = 'fingering';
  static const String sport = 'sport';
  static const String dk = 'dk';
  static const String worsted = 'worsted';
  static const String aran = 'aran';
  static const String bulky = 'bulky';
  static const String superBulky = 'superBulky';

  static const List<String> all = <String>[
    lace,
    fingering,
    sport,
    dk,
    worsted,
    aran,
    bulky,
    superBulky,
  ];

  static String label(String weight) {
    switch (weight) {
      case lace:
        return 'Lace';
      case fingering:
        return 'Fingering';
      case sport:
        return 'Sport';
      case dk:
        return 'DK';
      case worsted:
        return 'Worsted';
      case aran:
        return 'Aran';
      case bulky:
        return 'Bulky';
      case superBulky:
        return 'Super Bulky';
      default:
        return weight;
    }
  }
}
