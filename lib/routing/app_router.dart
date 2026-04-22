import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/strings.dart';
import '../features/counter/screens/counter_screen.dart';
import '../features/projects/screens/projects_screen.dart';
import '../features/projects/screens/new_project_screen.dart';
import '../features/projects/screens/project_detail_screen.dart';
import '../features/projects/screens/edit_project_screen.dart';
import '../features/dictionary/screens/dictionary_screen.dart';
import '../features/dictionary/screens/stitch_detail_screen.dart';
import '../features/stash/screens/stash_screen.dart';
import '../features/stash/screens/new_yarn_screen.dart';
import '../features/stash/screens/yarn_detail_screen.dart';
import '../features/stash/screens/edit_yarn_screen.dart';
import '../features/calculator/screens/calculator_screen.dart';

/// go_router configuration for StitchMate.
///
/// Uses a [StatefulShellRoute] to maintain state across the 5 main tabs.
/// BottomNavigationBar is used on phones; NavigationRail on tablets (>600dp).
///
/// Never use Navigator.push() — all navigation goes through this router.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          // ── Home / Dashboard ──
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                path: '/',
                builder: (context, state) => const CounterScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'counter',
                    builder: (context, state) => const CounterScreen(),
                  ),
                ],
              ),
            ],
          ),
          // ── Projects ──
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                path: '/projects',
                builder: (context, state) => const ProjectsScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const NewProjectScreen(),
                  ),
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) {
                      final projectId = state.extra as String?;
                      if (projectId == null) {
                        return const Scaffold(
                          body: Center(child: Text('No project selected')),
                        );
                      }
                      return ProjectDetailScreen(projectId: projectId);
                    },
                  ),
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final projectId = state.extra as String?;
                      if (projectId == null) {
                        return const Scaffold(
                          body: Center(child: Text('No project selected')),
                        );
                      }
                      return EditProjectScreen(projectId: projectId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // ── Dictionary ──
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                path: '/dictionary',
                builder: (context, state) => const DictionaryScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) {
                      final stitchId = state.extra as String?;
                      if (stitchId == null) {
                        return const Scaffold(
                          body: Center(child: Text('No stitch selected')),
                        );
                      }
                      return StitchDetailScreen(stitchId: stitchId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // ── Stash ──
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                path: '/stash',
                builder: (context, state) => const StashScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const NewYarnScreen(),
                  ),
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) {
                      final yarnId = state.extra as String?;
                      if (yarnId == null) {
                        return const Scaffold(
                          body: Center(child: Text('No yarn selected')),
                        );
                      }
                      return YarnDetailScreen(yarnId: yarnId);
                    },
                  ),
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final yarnId = state.extra as String?;
                      if (yarnId == null) {
                        return const Scaffold(
                          body: Center(child: Text('No yarn selected')),
                        );
                      }
                      return EditYarnScreen(yarnId: yarnId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // ── Tools ──
          StatefulShellBranch(
            routes: <GoRoute>[
              GoRoute(
                path: '/tools',
                builder: (context, state) => const CalculatorScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Responsive scaffold with BottomNavigationBar (phone) or NavigationRail (tablet).
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 600;
        return Scaffold(
          body: isTablet
              ? Row(
                  children: <Widget>[
                    NavigationRail(
                      selectedIndex: navigationShell.currentIndex,
                      onDestinationSelected: (int index) {
                        _onTap(context, index);
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: const <NavigationRailDestination>[
                        NavigationRailDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: Text(AppStrings.tabHome),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.folder_outlined),
                          selectedIcon: Icon(Icons.folder),
                          label: Text(AppStrings.tabProjects),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.menu_book_outlined),
                          selectedIcon: Icon(Icons.menu_book),
                          label: Text(AppStrings.tabDictionary),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.yard_outlined),
                          selectedIcon: Icon(Icons.yard),
                          label: Text(AppStrings.tabStash),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.build_outlined),
                          selectedIcon: Icon(Icons.build),
                          label: Text(AppStrings.tabTools),
                        ),
                      ],
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                    Expanded(child: navigationShell),
                  ],
                )
              : navigationShell,
          bottomNavigationBar: isTablet
              ? null
              : BottomNavigationBar(
                  currentIndex: navigationShell.currentIndex,
                  onTap: (int index) => _onTap(context, index),
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: AppStrings.tabHome,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.folder_outlined),
                      activeIcon: Icon(Icons.folder),
                      label: AppStrings.tabProjects,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu_book_outlined),
                      activeIcon: Icon(Icons.menu_book),
                      label: AppStrings.tabDictionary,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.yard_outlined),
                      activeIcon: Icon(Icons.yard),
                      label: AppStrings.tabStash,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.build_outlined),
                      activeIcon: Icon(Icons.build),
                      label: AppStrings.tabTools,
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
