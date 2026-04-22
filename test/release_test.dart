import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_mate/core/strings.dart';
import 'package:stitch_mate/features/settings/screens/data_export_import_screen.dart';
import 'package:stitch_mate/features/settings/screens/privacy_policy_screen.dart';

/// Build a testable widget wrapped in ProviderScope.
Widget _buildTestable(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  group('DataExportImportScreen', () {
    testWidgets('shows export and import sections', (tester) async {
      await tester.pumpWidget(_buildTestable(const DataExportImportScreen()));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.dataExport), findsWidgets);
      expect(find.text(AppStrings.dataImport), findsWidgets);
    });

    testWidgets('export button is present', (tester) async {
      await tester.pumpWidget(_buildTestable(const DataExportImportScreen()));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.dataExport), findsWidgets);
    });

    testWidgets('import button is present', (tester) async {
      await tester.pumpWidget(_buildTestable(const DataExportImportScreen()));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.dataImport), findsWidgets);
    });
  });

  group('PrivacyPolicyScreen', () {
    testWidgets('shows privacy policy title', (tester) async {
      await tester.pumpWidget(_buildTestable(const PrivacyPolicyScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('shows all policy sections', (tester) async {
      await tester.pumpWidget(_buildTestable(const PrivacyPolicyScreen()));
      await tester.pumpAndSettle();

      expect(find.text('1. Data Collection'), findsOneWidget);
      expect(find.text('2. Data Storage'), findsOneWidget);
      expect(find.text('3. Data Export'), findsOneWidget);
      expect(find.text('4. Permissions'), findsOneWidget);
      expect(find.text('5. Third-Party Services'), findsOneWidget);
      expect(find.text('6. Contact'), findsOneWidget);
    });
  });
}
