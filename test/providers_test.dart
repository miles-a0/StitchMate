import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stitch_mate/core/providers.dart';

void main() {
  group('Riverpod Provider Tests', () {
    test('helloWorldProvider returns correct string', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final value = container.read(helloWorldProvider);
      expect(value, 'Hello from Riverpod v2');
    });

    test('themeModeProvider defaults to system', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final value = container.read(themeModeProvider);
      expect(value, ThemeModeOption.system);
    });

    test('proStatusProvider defaults to false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final value = container.read(proStatusProvider);
      expect(value, false);
    });

    test('appLoadingProvider defaults to false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final value = container.read(appLoadingProvider);
      expect(value, false);
    });

    test('appLoadingProvider can be updated', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(appLoadingProvider.notifier);
      notifier.state = true;

      final value = container.read(appLoadingProvider);
      expect(value, true);
    });
  });
}
