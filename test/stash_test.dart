import 'package:flutter_test/flutter_test.dart';

import 'package:stitch_mate/data/models/yarn.dart';
import 'package:stitch_mate/features/stash/stash_provider.dart';

void main() {
  group('Yarn Model', () {
    test('Yarn copyWith updates fields', () {
      const yarn = Yarn(
        id: '1',
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );

      final updated = yarn.copyWith(
        brand: 'Cascade',
        skeinCount: 5,
      );

      expect(updated.brand, 'Cascade');
      expect(updated.skeinCount, 5);
      expect(updated.colourName, 'Sunset'); // unchanged
    });

    test('Yarn totalYardage calculates correctly', () {
      const yarn = Yarn(
        id: '1',
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );

      expect(yarn.totalYardage, 630);
      expect(yarn.totalMetreage, 576);
      expect(yarn.totalGrams, 300);
    });

    test('Yarn linkToProject adds project and sets status', () {
      const yarn = Yarn(
        id: '1',
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );

      final linked = yarn.linkToProject('proj1');

      expect(linked.linkedProjectIds, <String>['proj1']);
      expect(linked.status, YarnStatus.inUse);
    });

    test('Yarn unlinkFromProject removes project and resets status', () {
      final yarn = const Yarn(
        id: '1',
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
        linkedProjectIds: <String>['proj1'],
        status: YarnStatus.inUse,
      ).unlinkFromProject('proj1');

      expect(yarn.linkedProjectIds, isEmpty);
      expect(yarn.status, YarnStatus.available);
    });

    test('Yarn clearPurchaseLocation removes field', () {
      const yarn = Yarn(
        id: '1',
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
        purchaseLocation: 'Local Yarn Shop',
      );

      final cleared = yarn.clearPurchaseLocation();
      expect(cleared.purchaseLocation, null);
    });

    test('YarnWeight label returns correct strings', () {
      expect(YarnWeight.label(YarnWeight.lace), 'Lace');
      expect(YarnWeight.label(YarnWeight.fingering), 'Fingering');
      expect(YarnWeight.label(YarnWeight.worsted), 'Worsted');
      expect(YarnWeight.label(YarnWeight.superBulky), 'Super Bulky');
    });
  });

  group('YarnState', () {
    test('YarnState copyWith updates fields', () {
      const state = YarnState();
      final updated = state.copyWith(
        searchQuery: 'malabrigo',
        selectedWeight: YarnWeight.worsted,
      );

      expect(updated.searchQuery, 'malabrigo');
      expect(updated.selectedWeight, YarnWeight.worsted);
      expect(updated.isLoading, true); // unchanged
    });

    test('YarnState clearError removes error', () {
      const state = YarnState(error: 'Some error');
      final cleared = state.clearError();

      expect(cleared.error, null);
    });

    test('YarnState clearWeight removes weight filter', () {
      const state = YarnState(selectedWeight: YarnWeight.worsted);
      final cleared = state.clearWeight();

      expect(cleared.selectedWeight, null);
    });

    test('YarnState totalSkeins calculates correctly', () {
      const state = YarnState(
        yarns: <Yarn>[
          Yarn(
            id: '1',
            brand: 'A',
            colourName: 'Red',
            weight: YarnWeight.worsted,
            fibre: 'Wool',
            yardagePerSkein: 100,
            metreagePerSkein: 90,
            gramsPerSkein: 50,
            skeinCount: 3,
            hexColour: '#FF0000',
          ),
          Yarn(
            id: '2',
            brand: 'B',
            colourName: 'Blue',
            weight: YarnWeight.dk,
            fibre: 'Cotton',
            yardagePerSkein: 100,
            metreagePerSkein: 90,
            gramsPerSkein: 50,
            skeinCount: 2,
            hexColour: '#0000FF',
          ),
        ],
        isLoading: false,
      );

      expect(state.totalSkeins, 5);
      expect(state.totalYarns, 2);
    });
  });

  group('YarnNotifier Logic', () {
    test('createYarn adds yarn to state', () {
      final notifier = YarnNotifier(isPro: true);

      notifier.createYarn(
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino Wool',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );

      expect(notifier.state.yarns.length, 1);
      expect(notifier.state.yarns.first.brand, 'Malabrigo');
      expect(notifier.state.yarns.first.totalYardage, 630);
    });

    test('updateYarn modifies existing yarn', () {
      final notifier = YarnNotifier(isPro: true);
      notifier.createYarn(
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );

      final yarn = notifier.state.yarns.first;
      final updated = yarn.copyWith(brand: 'Cascade');
      notifier.updateYarn(updated);

      expect(notifier.state.yarns.first.brand, 'Cascade');
    });

    test('deleteYarn removes yarn', () {
      final notifier = YarnNotifier(isPro: true);
      notifier.createYarn(
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );

      final id = notifier.state.yarns.first.id;
      notifier.deleteYarn(id);

      expect(notifier.state.yarns.isEmpty, true);
    });

    test('updateStatus changes yarn status', () {
      final notifier = YarnNotifier(isPro: true);
      notifier.createYarn(
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );

      final id = notifier.state.yarns.first.id;
      notifier.updateStatus(id, YarnStatus.inUse);

      expect(notifier.state.yarns.first.status, YarnStatus.inUse);
    });

    test('linkToProject links yarn to project', () {
      final notifier = YarnNotifier(isPro: true);
      notifier.createYarn(
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );

      final id = notifier.state.yarns.first.id;
      notifier.linkToProject(id, 'proj1');

      expect(notifier.state.yarns.first.linkedProjectIds, <String>['proj1']);
      expect(notifier.state.yarns.first.status, YarnStatus.inUse);
    });

    test('unlinkFromProject unlinks yarn from project', () {
      final notifier = YarnNotifier(isPro: true);
      notifier.createYarn(
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );

      final id = notifier.state.yarns.first.id;
      notifier.linkToProject(id, 'proj1');
      notifier.unlinkFromProject(id, 'proj1');

      expect(notifier.state.yarns.first.linkedProjectIds, isEmpty);
      expect(notifier.state.yarns.first.status, YarnStatus.available);
    });

    test('search filters by brand', () {
      final notifier = YarnNotifier(isPro: true);
      notifier.createYarn(
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );
      notifier.createYarn(
        brand: 'Cascade',
        colourName: 'Blue',
        weight: YarnWeight.dk,
        fibre: 'Wool',
        yardagePerSkein: 220,
        metreagePerSkein: 200,
        gramsPerSkein: 100,
        skeinCount: 2,
        hexColour: '#0000FF',
      );

      notifier.search('mal');

      expect(notifier.state.filteredYarns.length, 1);
      expect(notifier.state.filteredYarns.first.brand, 'Malabrigo');
    });

    test('setWeightFilter filters by weight', () {
      final notifier = YarnNotifier(isPro: true);
      notifier.createYarn(
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );
      notifier.createYarn(
        brand: 'Cascade',
        colourName: 'Blue',
        weight: YarnWeight.dk,
        fibre: 'Wool',
        yardagePerSkein: 220,
        metreagePerSkein: 200,
        gramsPerSkein: 100,
        skeinCount: 2,
        hexColour: '#0000FF',
      );

      notifier.setWeightFilter(YarnWeight.worsted);

      expect(notifier.state.filteredYarns.length, 1);
      expect(notifier.state.filteredYarns.first.weight, YarnWeight.worsted);
    });

    test('setStatusFilter filters by status', () {
      final notifier = YarnNotifier(isPro: true);
      notifier.createYarn(
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );

      final id = notifier.state.yarns.first.id;
      notifier.updateStatus(id, YarnStatus.inUse);
      notifier.setStatusFilter(YarnStatus.available);

      expect(notifier.state.filteredYarns.isEmpty, true);
    });

    test('getYarnById returns correct yarn', () {
      final notifier = YarnNotifier(isPro: true);
      notifier.createYarn(
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );

      final id = notifier.state.yarns.first.id;
      final found = notifier.getYarnById(id);

      expect(found, isNotNull);
      expect(found!.brand, 'Malabrigo');
    });

    test('getYarnById returns null for unknown id', () {
      final notifier = YarnNotifier(isPro: true);

      final found = notifier.getYarnById('unknown');

      expect(found, null);
    });

    test('hasEnoughYarn returns correct result', () {
      final notifier = YarnNotifier(isPro: true);
      notifier.createYarn(
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );

      final id = notifier.state.yarns.first.id;

      expect(notifier.hasEnoughYarn(id, 500), true); // 630 >= 500
      expect(notifier.hasEnoughYarn(id, 700), false); // 630 < 700
    });

    test('calculateSkeinsNeeded returns correct count', () {
      final notifier = YarnNotifier(isPro: true);
      notifier.createYarn(
        brand: 'Malabrigo',
        colourName: 'Sunset',
        weight: YarnWeight.worsted,
        fibre: 'Merino',
        yardagePerSkein: 210,
        metreagePerSkein: 192,
        gramsPerSkein: 100,
        skeinCount: 3,
        hexColour: '#FF5733',
      );

      final id = notifier.state.yarns.first.id;

      expect(notifier.calculateSkeinsNeeded(id, 400), 2); // 400/210 = 1.9 -> 2
      expect(notifier.calculateSkeinsNeeded(id, 210), 1);
      expect(notifier.calculateSkeinsNeeded(id, 420), 2);
    });
  });
}
