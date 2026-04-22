/// Static reference data for yarn weights and WPI ranges.
///
/// WPI = Wraps Per Inch — a method of measuring yarn thickness by wrapping
/// yarn around a ruler and counting wraps in one inch.
class YarnWeightData {
  YarnWeightData._();

  // Weight string constants (matching Yarn model).
  static const String lace = 'lace';
  static const String fingering = 'fingering';
  static const String sport = 'sport';
  static const String dk = 'dk';
  static const String worsted = 'worsted';
  static const String aran = 'aran';
  static const String bulky = 'bulky';
  static const String superBulky = 'superBulky';

  /// All yarn weight entries with WPI ranges and needle/hook recommendations.
  static const List<YarnWeightEntry> allWeights = [
    YarnWeightEntry(
      weight: lace,
      label: 'Lace',
      wpiRange: '18+',
      wpiMin: 18,
      wpiMax: 99,
      description:
          'Very fine, delicate yarn. Used for lightweight shawls, doilies, and intricate lace patterns.',
      needleRangeMetric: '1.5–2.25 mm',
      needleRangeUs: 'US 000–1',
      hookRangeMetric: '1.6–1.4 mm',
      hookRangeUs: 'Steel 6–8',
      gaugeStitches10cm: '32–40',
    ),
    YarnWeightEntry(
      weight: fingering,
      label: 'Fingering / Sock',
      wpiRange: '14–17',
      wpiMin: 14,
      wpiMax: 17,
      description:
          'Lightweight yarn perfect for socks, shawls, and baby garments. Also called 4-ply in the UK.',
      needleRangeMetric: '2.25–3.25 mm',
      needleRangeUs: 'US 1–3',
      hookRangeMetric: '2.25–3.5 mm',
      hookRangeUs: 'B/1–E/4',
      gaugeStitches10cm: '27–32',
    ),
    YarnWeightEntry(
      weight: sport,
      label: 'Sport',
      wpiRange: '12–14',
      wpiMin: 12,
      wpiMax: 14,
      description:
          'Light DK weight. Good for lightweight garments, baby items, and colourwork.',
      needleRangeMetric: '3.25–3.75 mm',
      needleRangeUs: 'US 3–5',
      hookRangeMetric: '3.5–4.5 mm',
      hookRangeUs: 'E/4–7',
      gaugeStitches10cm: '23–26',
    ),
    YarnWeightEntry(
      weight: dk,
      label: 'DK / Light Worsted',
      wpiRange: '11–13',
      wpiMin: 11,
      wpiMax: 13,
      description:
          'Double knitting weight. Versatile for garments, accessories, and blankets. Also called 8-ply.',
      needleRangeMetric: '3.75–4.5 mm',
      needleRangeUs: 'US 5–7',
      hookRangeMetric: '4.0–5.5 mm',
      hookRangeUs: 'G/6–I/9',
      gaugeStitches10cm: '21–24',
    ),
    YarnWeightEntry(
      weight: worsted,
      label: 'Worsted / Aran',
      wpiRange: '9–11',
      wpiMin: 9,
      wpiMax: 11,
      description:
          'Medium weight — the most common yarn weight. Ideal for sweaters, scarves, and blankets.',
      needleRangeMetric: '4.5–5.5 mm',
      needleRangeUs: 'US 7–9',
      hookRangeMetric: '5.5–6.5 mm',
      hookRangeUs: 'I/9–K/10.5',
      gaugeStitches10cm: '16–20',
    ),
    YarnWeightEntry(
      weight: aran,
      label: 'Aran / Heavy Worsted',
      wpiRange: '8–10',
      wpiMin: 8,
      wpiMax: 10,
      description:
          'Slightly heavier than worsted. Great for warm sweaters, cardigans, and cosy accessories.',
      needleRangeMetric: '5.0–5.5 mm',
      needleRangeUs: 'US 8–9',
      hookRangeMetric: '5.5–6.5 mm',
      hookRangeUs: 'I/9–K/10.5',
      gaugeStitches10cm: '16–18',
    ),
    YarnWeightEntry(
      weight: bulky,
      label: 'Bulky / Chunky',
      wpiRange: '7–8',
      wpiMin: 7,
      wpiMax: 8,
      description:
          'Thick yarn that works up quickly. Perfect for warm blankets, hats, and scarves.',
      needleRangeMetric: '5.5–8.0 mm',
      needleRangeUs: 'US 9–11',
      hookRangeMetric: '6.5–9.0 mm',
      hookRangeUs: 'K/10.5–M/13',
      gaugeStitches10cm: '12–15',
    ),
    YarnWeightEntry(
      weight: superBulky,
      label: 'Super Bulky / Roving',
      wpiRange: '5–6',
      wpiMin: 5,
      wpiMax: 6,
      description:
          'Very thick yarn for quick projects. Ideal for chunky blankets, cowls, and statement pieces.',
      needleRangeMetric: '8.0–12.0 mm',
      needleRangeUs: 'US 11–17',
      hookRangeMetric: '9.0–15.0 mm',
      hookRangeUs: 'M/13–Q',
      gaugeStitches10cm: '7–11',
    ),
  ];

  /// Get a weight entry by its string value.
  static YarnWeightEntry? getByWeight(String weight) {
    for (final entry in allWeights) {
      if (entry.weight == weight) return entry;
    }
    return null;
  }

  /// Identify yarn weight from WPI value.
  static YarnWeightEntry? identifyByWpi(int wpi) {
    for (final entry in allWeights) {
      if (wpi >= entry.wpiMin && wpi <= entry.wpiMax) {
        return entry;
      }
    }
    return null;
  }
}

/// A single yarn weight reference entry.
class YarnWeightEntry {
  const YarnWeightEntry({
    required this.weight,
    required this.label,
    required this.wpiRange,
    required this.wpiMin,
    required this.wpiMax,
    required this.description,
    required this.needleRangeMetric,
    required this.needleRangeUs,
    required this.hookRangeMetric,
    required this.hookRangeUs,
    required this.gaugeStitches10cm,
  });

  final String weight;
  final String label;
  final String wpiRange;
  final int wpiMin;
  final int wpiMax;
  final String description;
  final String needleRangeMetric;
  final String needleRangeUs;
  final String hookRangeMetric;
  final String hookRangeUs;
  final String gaugeStitches10cm;
}
