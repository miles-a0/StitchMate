import 'package:flutter/material.dart';

/// Reusable responsive layout wrapper.
///
/// Breakpoint at 600dp:
/// - < 600dp: returns [mobileLayout]
/// - >= 600dp: returns [tabletLayout]
///
/// Use this on every screen that has a list or complex layout.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobileLayout,
    required this.tabletLayout,
    super.key,
  });

  final Widget mobileLayout;
  final Widget tabletLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return tabletLayout;
        }
        return mobileLayout;
      },
    );
  }
}

/// Convenience widget for responsive padding.
///
/// Applies [mobilePadding] on phones and [tabletPadding] on tablets.
class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({
    required this.child,
    this.mobilePadding = const EdgeInsets.all(16),
    this.tabletPadding = const EdgeInsets.all(24),
    super.key,
  });

  final Widget child;
  final EdgeInsets mobilePadding;
  final EdgeInsets tabletPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: constraints.maxWidth >= 600 ? tabletPadding : mobilePadding,
          child: child,
        );
      },
    );
  }
}

/// Convenience widget for responsive column count.
///
/// Returns [mobileColumns] on phones and [tabletColumns] on tablets.
/// Useful for GridView crossAxisCount.
class ResponsiveColumns extends StatelessWidget {
  const ResponsiveColumns({
    required this.mobileColumns,
    required this.tabletColumns,
    required this.builder,
    super.key,
  });

  final int mobileColumns;
  final int tabletColumns;
  final Widget Function(BuildContext context, int columns) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            constraints.maxWidth >= 600 ? tabletColumns : mobileColumns;
        return builder(context, columns);
      },
    );
  }
}
