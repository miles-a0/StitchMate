/// Static reference data for needle and hook sizes.
///
/// Covers knitting needles (US / metric mm / UK/Canada) and
/// crochet hooks (US letter / metric mm).
class NeedleSizeData {
  NeedleSizeData._();

  /// Knitting needle conversion chart.
  /// US size, metric mm, UK/Canada size.
  static const List<NeedleSizeEntry> knittingNeedles = [
    NeedleSizeEntry(usSize: '0', metricMm: 2.0, ukSize: '14'),
    NeedleSizeEntry(usSize: '1', metricMm: 2.25, ukSize: '13'),
    NeedleSizeEntry(usSize: '1.5', metricMm: 2.5, ukSize: '-'),
    NeedleSizeEntry(usSize: '2', metricMm: 2.75, ukSize: '12'),
    NeedleSizeEntry(usSize: '2.5', metricMm: 3.0, ukSize: '11'),
    NeedleSizeEntry(usSize: '3', metricMm: 3.25, ukSize: '10'),
    NeedleSizeEntry(usSize: '4', metricMm: 3.5, ukSize: '-'),
    NeedleSizeEntry(usSize: '5', metricMm: 3.75, ukSize: '9'),
    NeedleSizeEntry(usSize: '6', metricMm: 4.0, ukSize: '8'),
    NeedleSizeEntry(usSize: '7', metricMm: 4.5, ukSize: '7'),
    NeedleSizeEntry(usSize: '8', metricMm: 5.0, ukSize: '6'),
    NeedleSizeEntry(usSize: '9', metricMm: 5.5, ukSize: '5'),
    NeedleSizeEntry(usSize: '10', metricMm: 6.0, ukSize: '4'),
    NeedleSizeEntry(usSize: '10.5', metricMm: 6.5, ukSize: '3'),
    NeedleSizeEntry(usSize: '11', metricMm: 8.0, ukSize: '0'),
    NeedleSizeEntry(usSize: '13', metricMm: 9.0, ukSize: '00'),
    NeedleSizeEntry(usSize: '15', metricMm: 10.0, ukSize: '000'),
    NeedleSizeEntry(usSize: '17', metricMm: 12.0, ukSize: '-'),
    NeedleSizeEntry(usSize: '19', metricMm: 15.0, ukSize: '-'),
    NeedleSizeEntry(usSize: '35', metricMm: 19.0, ukSize: '-'),
    NeedleSizeEntry(usSize: '50', metricMm: 25.0, ukSize: '-'),
  ];

  /// Crochet hook conversion chart.
  /// US letter, metric mm.
  static const List<CrochetHookEntry> crochetHooks = [
    CrochetHookEntry(usLetter: 'B/1', metricMm: 2.25),
    CrochetHookEntry(usLetter: 'C/2', metricMm: 2.75),
    CrochetHookEntry(usLetter: 'D/3', metricMm: 3.125),
    CrochetHookEntry(usLetter: 'E/4', metricMm: 3.5),
    CrochetHookEntry(usLetter: 'F/5', metricMm: 3.75),
    CrochetHookEntry(usLetter: 'G/6', metricMm: 4.0),
    CrochetHookEntry(usLetter: '7', metricMm: 4.5),
    CrochetHookEntry(usLetter: 'H/8', metricMm: 5.0),
    CrochetHookEntry(usLetter: 'I/9', metricMm: 5.5),
    CrochetHookEntry(usLetter: 'J/10', metricMm: 6.0),
    CrochetHookEntry(usLetter: 'K/10.5', metricMm: 6.5),
    CrochetHookEntry(usLetter: 'L/11', metricMm: 8.0),
    CrochetHookEntry(usLetter: 'M/13', metricMm: 9.0),
    CrochetHookEntry(usLetter: 'N/15', metricMm: 10.0),
    CrochetHookEntry(usLetter: 'P/16', metricMm: 11.5),
    CrochetHookEntry(usLetter: 'Q', metricMm: 15.0),
    CrochetHookEntry(usLetter: 'S', metricMm: 19.0),
  ];
}

/// A single knitting needle size entry.
class NeedleSizeEntry {
  const NeedleSizeEntry({
    required this.usSize,
    required this.metricMm,
    required this.ukSize,
  });

  final String usSize;
  final double metricMm;
  final String ukSize;
}

/// A single crochet hook size entry.
class CrochetHookEntry {
  const CrochetHookEntry({
    required this.usLetter,
    required this.metricMm,
  });

  final String usLetter;
  final double metricMm;
}
