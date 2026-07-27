import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/note_detail_screen.dart';
import '../screens/settings.dart';
import '../screens/about_app_screen.dart';
import '../screens/advanced_settings_screen.dart';
import '../screens/theme_color_screen.dart';
import '../screens/backup_screen.dart';
import '../screens/restore_screen.dart';
import '../screens/restore_confirm_screen.dart';
import '../screens/diagnostics_screen.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../models/note.dart';

// SharedAxisTransition cần cả 2 màn hình dùng cùng transition type
// để animation enter/exit được phối hợp đúng.
// fillColor tránh render màn hình cũ xuyên suốt transition → nhẹ GPU hơn.
Page<T> _buildTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  if (!themeProvider.enableAnimations) {
    return NoTransitionPage<T>(
      key: state.pageKey,
      child: child,
    );
  }
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.horizontal,
        child: child,
      );
    },
  );
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Route chính
    GoRoute(
      path: '/',
      // FIX: Dùng _buildTransition thay vì NoTransitionPage
      // NoTransitionPage không có secondaryAnimation → SharedAxisTransition bị lệch
      // khi HomeScreen exit sang settings/note_detail
      pageBuilder: (context, state) => _buildTransition(
        context: context,
        state: state,
        child: const HomeScreen(),
      ),
      routes: [
        GoRoute(
          path: 'note/:id',
          pageBuilder: (context, state) => _buildTransition(
            context: context,
            state: state,
            child: NoteDetailScreen(note: state.extra as Note),
          ),
        ),
        GoRoute(
          path: 'settings',
          pageBuilder: (context, state) => _buildTransition(
            context: context,
            state: state,
            child: const SettingsScreen(),
          ),
          routes: [
            GoRoute(
              path: 'about',
              pageBuilder: (context, state) => _buildTransition(
                context: context,
                state: state,
                child: const AboutAppScreen(),
              ),
            ),
            GoRoute(
              path: 'advanced',
              pageBuilder: (context, state) => _buildTransition(
                context: context,
                state: state,
                child: const AdvancedSettingsScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'color',
                  pageBuilder: (context, state) => _buildTransition(
                    context: context,
                    state: state,
                    child: const ThemeColorScreen(),
                  ),
                ),
                GoRoute(
                  path: 'backup',
                  pageBuilder: (context, state) => _buildTransition(
                    context: context,
                    state: state,
                    child: const BackupScreen(),
                  ),
                ),
                GoRoute(
                  path: 'restore/select',
                  pageBuilder: (context, state) => _buildTransition(
                    context: context,
                    state: state,
                    child: RestoreSelectScreen(
                      notes: state.extra as List<Note>,
                    ),
                  ),
                ),
                GoRoute(
                  path: 'restore/confirm',
                  pageBuilder: (context, state) => _buildTransition(
                    context: context,
                    state: state,
                    child: RestoreScreen(
                      notes: state.extra as List<Note>,
                    ),
                  ),
                ),
                GoRoute(
                  path: 'diagnostics',
                  pageBuilder: (context, state) => _buildTransition(
                    context: context,
                    state: state,
                    child: const DiagnosticsScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
