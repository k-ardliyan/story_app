import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/story/data/models/story_item.dart';
import '../shared/widgets/status_view.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/viewmodels/auth_view_model.dart';
import '../features/story/presentation/pages/add_story_page.dart';
import '../features/story/presentation/pages/home_page.dart';
import '../features/story/presentation/pages/story_detail_page.dart';

class AppRouter {
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String homePath = '/home';
  static const String storyPath = '/story';
  static const String addStoryPath = '/add-story';

  static GoRouter createRouter({required AuthViewModel authViewModel}) {
    return GoRouter(
      initialLocation: homePath,
      refreshListenable: authViewModel,
      redirect: (BuildContext context, GoRouterState state) {
        final String path = state.matchedLocation;
        final bool isAuthRoute = path == loginPath || path == registerPath;

        if (!authViewModel.isInitialized) {
          return null;
        }

        if (!authViewModel.isLoggedIn && !isAuthRoute) {
          return loginPath;
        }

        if (authViewModel.isLoggedIn && isAuthRoute) {
          return homePath;
        }

        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: loginPath,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: registerPath,
          builder: (BuildContext context, GoRouterState state) {
            return const RegisterPage();
          },
        ),
        GoRoute(
          path: homePath,
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: '$storyPath/:id',
          builder: (BuildContext context, GoRouterState state) {
            final String? id = state.pathParameters['id'];
            if (id == null || id.isEmpty) {
              return const _MissingStoryPage();
            }
            final StoryItem? initialStory = state.extra is StoryItem
                ? state.extra as StoryItem
                : null;
            return StoryDetailPage(storyId: id, initialStory: initialStory);
          },
        ),
        GoRoute(
          path: addStoryPath,
          builder: (BuildContext context, GoRouterState state) {
            return const AddStoryPage();
          },
        ),
      ],
    );
  }
}

class _MissingStoryPage extends StatelessWidget {
  const _MissingStoryPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: StatusView(
        icon: Icons.find_in_page_outlined,
        type: StatusViewType.empty,
        title: 'Story not found.',
      ),
    );
  }
}
