import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'core/providers.dart';
import 'data/local/hive_init.dart';
import 'features/settings/settings_provider.dart';
import 'features/settings/screens/onboarding_screen.dart';
import 'routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive before running the app.
  await HiveInit.initialise();

  runApp(const ProviderScope(child: StitchMateApp()));
}

class StitchMateApp extends ConsumerWidget {
  const StitchMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final settings = ref.watch(settingsProvider);

    // Show onboarding on first launch.
    if (!settings.hasCompletedOnboarding) {
      return MaterialApp(
        title: 'StitchMate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _mapThemeMode(themeMode),
        home: const OnboardingScreen(),
      );
    }

    return MaterialApp.router(
      title: 'StitchMate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _mapThemeMode(themeMode),
      routerConfig: router,
    );
  }

  ThemeMode _mapThemeMode(ThemeModeOption option) {
    switch (option) {
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.system:
        return ThemeMode.system;
    }
  }
}
