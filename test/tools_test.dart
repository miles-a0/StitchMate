import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_mate/features/calculator/data/needle_size_data.dart';
import 'package:stitch_mate/features/calculator/data/yarn_weight_data.dart';

void main() {
  group('NeedleSizeData', () {
    test('knittingNeedles has entries', () {
      expect(NeedleSizeData.knittingNeedles, isNotEmpty);
    });

    test('knittingNeedles US 6 is 4.0mm', () {
      final entry = NeedleSizeData.knittingNeedles.firstWhere(
        (e) => e.usSize == '6',
      );
      expect(entry.metricMm, 4.0);
      expect(entry.ukSize, '8');
    });

    test('knittingNeedles US 8 is 5.0mm', () {
      final entry = NeedleSizeData.knittingNeedles.firstWhere(
        (e) => e.usSize == '8',
      );
      expect(entry.metricMm, 5.0);
    });

    test('crochetHooks has entries', () {
      expect(NeedleSizeData.crochetHooks, isNotEmpty);
    });

    test('crochetHooks G/6 is 4.0mm', () {
      final entry = NeedleSizeData.crochetHooks.firstWhere(
        (e) => e.usLetter == 'G/6',
      );
      expect(entry.metricMm, 4.0);
    });
  });

  group('YarnWeightData', () {
    test('allWeights has 8 entries', () {
      expect(YarnWeightData.allWeights.length, 8);
    });

    test('getByWeight returns correct entry', () {
      final entry = YarnWeightData.getByWeight(YarnWeightData.worsted);
      expect(entry, isNotNull);
      expect(entry!.label, 'Worsted / Aran');
    });

    test('getByWeight returns null for unknown weight', () {
      final entry = YarnWeightData.getByWeight('unknown');
      expect(entry, isNull);
    });

    test('identifyByWpi finds lace at 20 WPI', () {
      final entry = YarnWeightData.identifyByWpi(20);
      expect(entry, isNotNull);
      expect(entry!.weight, YarnWeightData.lace);
    });

    test('identifyByWpi finds fingering at 15 WPI', () {
      final entry = YarnWeightData.identifyByWpi(15);
      expect(entry, isNotNull);
      expect(entry!.weight, YarnWeightData.fingering);
    });

    test('identifyByWpi finds sport at 13 WPI', () {
      final entry = YarnWeightData.identifyByWpi(13);
      expect(entry, isNotNull);
      expect(entry!.weight, YarnWeightData.sport);
    });

    test('identifyByWpi finds dk at 11 WPI', () {
      final entry = YarnWeightData.identifyByWpi(11);
      expect(entry, isNotNull);
      expect(entry!.weight, YarnWeightData.dk);
    });

    test('identifyByWpi finds worsted at 10 WPI', () {
      final entry = YarnWeightData.identifyByWpi(10);
      expect(entry, isNotNull);
      expect(entry!.weight, YarnWeightData.worsted);
    });

    test('identifyByWpi finds bulky at 7 WPI', () {
      final entry = YarnWeightData.identifyByWpi(7);
      expect(entry, isNotNull);
      expect(entry!.weight, YarnWeightData.bulky);
    });

    test('identifyByWpi finds superBulky at 5 WPI', () {
      final entry = YarnWeightData.identifyByWpi(5);
      expect(entry, isNotNull);
      expect(entry!.weight, YarnWeightData.superBulky);
    });

    test('identifyByWpi returns null for out of range WPI', () {
      final entry = YarnWeightData.identifyByWpi(2);
      expect(entry, isNull);
    });

    test('each weight has valid WPI range', () {
      for (final entry in YarnWeightData.allWeights) {
        expect(entry.wpiMin, lessThanOrEqualTo(entry.wpiMax));
        expect(entry.wpiMin, greaterThan(0));
      }
    });
  });

  group('Gauge Calculator Logic', () {
    test('forward calculation metric', () {
      // 20 stitches per 10cm, target width 50cm
      // stitchesPerCm = 20 / 10 = 2
      // needed = 50 * 2 = 100
      const stitches = 20.0;
      const targetWidth = 50.0;
      const swatchSize = 10.0;

      const stitchesPerUnit = stitches / swatchSize;
      final needed = (targetWidth * stitchesPerUnit).round();

      expect(needed, 100);
    });

    test('forward calculation imperial', () {
      // 20 stitches per 4in, target width 20in
      // stitchesPerInch = 20 / 4 = 5
      // needed = 20 * 5 = 100
      const stitches = 20.0;
      const targetWidth = 20.0;
      const swatchSize = 4.0;

      const stitchesPerUnit = stitches / swatchSize;
      final needed = (targetWidth * stitchesPerUnit).round();

      expect(needed, 100);
    });

    test('reverse calculation metric', () {
      // 20 stitches per 10cm, 100 total stitches
      // stitchesPerCm = 20 / 10 = 2
      // width = 100 / 2 = 50cm
      const stitches = 20.0;
      const totalStitches = 100.0;
      const swatchSize = 10.0;

      const stitchesPerUnit = stitches / swatchSize;
      const width = totalStitches / stitchesPerUnit;

      expect(width, 50.0);
    });

    test('reverse calculation imperial', () {
      // 20 stitches per 4in, 100 total stitches
      // stitchesPerInch = 20 / 4 = 5
      // width = 100 / 5 = 20in
      const stitches = 20.0;
      const totalStitches = 100.0;
      const swatchSize = 4.0;

      const stitchesPerUnit = stitches / swatchSize;
      const width = totalStitches / stitchesPerUnit;

      expect(width, 20.0);
    });
  });
}
