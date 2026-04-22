import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch_mate/core/strings.dart';
import 'package:stitch_mate/features/calculator/screens/tools_screen.dart';
import 'package:stitch_mate/features/calculator/screens/gauge_calculator_screen.dart';
import 'package:stitch_mate/features/calculator/screens/wpi_calculator_screen.dart';
import 'package:stitch_mate/features/calculator/screens/needle_chart_screen.dart';
import 'package:stitch_mate/features/calculator/screens/yarn_weight_guide_screen.dart';

/// Build a testable widget wrapped in ProviderScope + MaterialApp.
Widget _buildTestable(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      home: child,
    ),
  );
}

/// Build a testable widget with GoRouter.
Widget _buildTestableWithRouter({
  required String initialLocation,
  required List<GoRoute> routes,
}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: routes,
  );

  return ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

void main() {
  group('ToolsScreen', () {
    testWidgets('shows all four tool cards', (tester) async {
      await tester.pumpWidget(_buildTestable(const ToolsScreen()));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.gaugeCalculator), findsOneWidget);
      expect(find.text(AppStrings.wpiCalculator), findsOneWidget);
      expect(find.text(AppStrings.needleChart), findsOneWidget);
      expect(find.text(AppStrings.yarnWeightGuide), findsOneWidget);
    });

    testWidgets('tapping gauge calculator navigates', (tester) async {
      await tester.pumpWidget(
        _buildTestableWithRouter(
          initialLocation: '/tools',
          routes: [
            GoRoute(
              path: '/tools',
              builder: (_, __) => const ToolsScreen(),
              routes: [
                GoRoute(
                  path: 'gauge',
                  builder: (_, __) => const GaugeCalculatorScreen(),
                ),
              ],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.gaugeCalculator));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.gaugeCalculator), findsWidgets);
    });
  });

  group('GaugeCalculatorScreen', () {
    testWidgets('shows unit toggle', (tester) async {
      await tester.pumpWidget(_buildTestable(const GaugeCalculatorScreen()));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.unitMetric), findsOneWidget);
      expect(find.text(AppStrings.unitImperial), findsOneWidget);
    });

    testWidgets('shows input fields', (tester) async {
      await tester.pumpWidget(_buildTestable(const GaugeCalculatorScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('calculates forward result', (tester) async {
      await tester.pumpWidget(_buildTestable(const GaugeCalculatorScreen()));
      await tester.pumpAndSettle();

      // Enter gauge: 20 stitches, 28 rows per 10cm.
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), '20');
      await tester.enterText(textFields.at(1), '28');

      // Enter target: 50cm width, 60cm height.
      await tester.enterText(textFields.at(2), '50');
      await tester.enterText(textFields.at(3), '60');

      await tester.tap(find.text(AppStrings.gaugeResult));
      await tester.pumpAndSettle();

      expect(find.text('100'), findsOneWidget); // stitches
      expect(find.text('168'), findsOneWidget); // rows
    });

    testWidgets('calculates reverse result', (tester) async {
      await tester.pumpWidget(_buildTestable(const GaugeCalculatorScreen()));
      await tester.pumpAndSettle();

      // Enter gauge: 20 stitches, 28 rows per 10cm.
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), '20');
      await tester.enterText(textFields.at(1), '28');

      // Enter total stitches and rows.
      await tester.enterText(textFields.at(4), '100');
      await tester.enterText(textFields.at(5), '140');

      await tester.tap(find.text('Calculate Size'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Finished width:'), findsOneWidget);
      expect(find.textContaining('Finished height:'), findsOneWidget);
    });
  });

  group('WpiCalculatorScreen', () {
    testWidgets('shows input field and reference table', (tester) async {
      await tester.pumpWidget(_buildTestable(const WpiCalculatorScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('WPI Reference'), findsOneWidget);
    });

    testWidgets('identifies yarn weight from WPI', (tester) async {
      await tester.pumpWidget(_buildTestable(const WpiCalculatorScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '12');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Tap the calculate button.
      await tester.tap(find.text(AppStrings.wpiResult));
      await tester.pumpAndSettle();

      expect(find.text('DK / Light Worsted'), findsOneWidget);
    });
  });

  group('NeedleChartScreen', () {
    testWidgets('shows tab bar with two tabs', (tester) async {
      await tester.pumpWidget(_buildTestable(const NeedleChartScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Knitting Needles'), findsOneWidget);
      expect(find.text('Crochet Hooks'), findsOneWidget);
    });

    testWidgets('shows knitting needle data', (tester) async {
      await tester.pumpWidget(_buildTestable(const NeedleChartScreen()));
      await tester.pumpAndSettle();

      expect(find.text('US Size'), findsOneWidget);
      expect(find.text('Metric (mm)'), findsOneWidget);
      expect(find.text('4.0 mm'), findsOneWidget);
    });

    testWidgets('shows crochet hook data on second tab', (tester) async {
      await tester.pumpWidget(_buildTestable(const NeedleChartScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Crochet Hooks'));
      await tester.pumpAndSettle();

      expect(find.text('US Letter'), findsOneWidget);
      expect(find.text('4.0 mm'), findsOneWidget);
    });
  });

  group('YarnWeightGuideScreen', () {
    testWidgets('shows yarn weight cards', (tester) async {
      await tester.pumpWidget(_buildTestable(const YarnWeightGuideScreen()));
      await tester.pumpAndSettle();

      // Verify first few visible cards.
      expect(find.text('Lace'), findsOneWidget);
      expect(find.text('Fingering / Sock'), findsOneWidget);

      // Scroll to find a later card.
      await tester.scrollUntilVisible(
        find.text('Super Bulky / Roving'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Super Bulky / Roving'), findsOneWidget);
    });
  });
}
