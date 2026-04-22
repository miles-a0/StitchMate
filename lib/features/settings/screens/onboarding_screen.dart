import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../settings_provider.dart';

/// Onboarding flow with 3 pages.
///
/// Shown on first app launch. Can be skipped.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const <_OnboardingPageData>[
    _OnboardingPageData(
      icon: Icons.home_outlined,
      title: AppStrings.onboardingWelcome,
      description:
          'Your all-in-one companion for knitting and crochet. Track projects, '
          'count rows, manage your stash, and more.',
    ),
    _OnboardingPageData(
      icon: Icons.exposure_plus_1,
      title: AppStrings.onboardingCounter,
      description:
          'Never lose your place again. Our large, thumb-friendly counter '
          'stays on screen with haptic feedback and lock mode.',
    ),
    _OnboardingPageData(
      icon: Icons.folder_outlined,
      title: AppStrings.onboardingProjects,
      description:
          'Organise every project with counters, timers, notes, and photos. '
          'Track your progress from start to finish.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Skip button.
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMD),
                child: TextButton(
                  onPressed: _finish,
                  child: const Text(AppStrings.skip),
                ),
              ),
            ),

            // Page content.
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: _pages[index]);
                },
              ),
            ),

            // Page indicator and navigation.
            Padding(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                children: <Widget>[
                  // Dots.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      return Container(
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingXS,
                        ),
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? colorScheme.primary
                              : colorScheme.outline,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusFull,
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: AppDimensions.spacingLG),

                  // Next / Done button.
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isLastPage ? _finish : _next,
                      child: Text(
                          _isLastPage ? AppStrings.gotIt : AppStrings.next),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _next() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finish() {
    ref.read(settingsProvider.notifier).completeOnboarding();
    try {
      context.go('/');
    } catch (_) {
      // GoRouter not available in test environment — safe to ignore.
    }
  }
}

/// Data for a single onboarding page.
class _OnboardingPageData {
  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

/// Single onboarding page.
class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Icon.
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: 56,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(height: AppDimensions.spacingXL),

          // Title.
          Text(
            data.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spacingMD),

          // Description.
          Text(
            data.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
