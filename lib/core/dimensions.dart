/// Spacing, sizing, and dimension constants for StitchMate.
///
/// Never use hardcoded numbers for spacing, sizing, border radius, or font sizes
/// in UI widgets. Always reference values from this file.
class AppDimensions {
  AppDimensions._();

  // ── Spacing ──
  static const double spacingXS = 4;
  static const double spacingSM = 8;
  static const double spacingMD = 16;
  static const double spacingLG = 24;
  static const double spacingXL = 32;
  static const double spacingXXL = 48;

  // ── Border Radius ──
  static const double radiusXS = 4;
  static const double radiusSM = 8;
  static const double radiusMD = 12;
  static const double radiusLG = 16;
  static const double radiusXL = 24;
  static const double radiusFull = 999;

  // ── Icon Sizes ──
  static const double iconSM = 16;
  static const double iconMD = 24;
  static const double iconLG = 32;
  static const double iconXL = 48;

  // ── Button / Tap Target ──
  static const double minTapTarget = 48;
  static const double buttonHeight = 48;
  static const double buttonHeightLarge = 56;

  // ── Counter ──
  static const double counterButtonMinHeight = 120;
  static const double counterButtonMinScreenRatio = 0.40;
  static const double counterFontSize = 96;
  static const double counterLabelFontSize = 18;

  // ── Card ──
  static const double cardPadding = 16;
  static const double cardElevation = 1;

  // ── Screen Padding ──
  static const double screenPadding = 16;
  static const double screenPaddingHorizontal = 16;
  static const double screenPaddingVertical = 16;

  // ── App Bar ──
  static const double appBarHeight = 56;

  // ── Bottom Nav ──
  static const double bottomNavHeight = 80;

  // ── Navigation Rail (tablet) ──
  static const double navRailWidth = 80;
  static const double navRailBreakpoint = 600;

  // ── List Tile ──
  static const double listTileMinHeight = 56;
  static const double listTileLeadingWidth = 56;

  // ── Divider ──
  static const double dividerThickness = 1;
  static const double dividerIndent = 16;

  // ── Form ──
  static const double formFieldHeight = 56;
  static const double formSpacing = 16;

  // ── Dialog ──
  static const double dialogMaxWidth = 400;
  static const double dialogPadding = 24;
  static const double dialogRadius = 28;

  // ── Snackbar ──
  static const double snackbarPadding = 16;

  // ── Image / Avatar ──
  static const double avatarRadius = 24;
  static const double avatarRadiusLarge = 40;
  static const double imageThumbnailSize = 64;
}
