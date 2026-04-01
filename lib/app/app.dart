import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/l10n/app_localizations.dart';

import '../core/theme/app_theme.dart';
import 'viewmodels/locale_view_model.dart';
import '../features/auth/presentation/viewmodels/auth_view_model.dart';
import '../features/story/data/repositories/story_repository.dart';
import '../features/story/presentation/viewmodels/story_list_view_model.dart';
import 'router.dart';

class StoryBloomApp extends StatefulWidget {
  const StoryBloomApp({
    super.key,
    required this.authViewModel,
    required this.localeViewModel,
    required this.storyListViewModel,
    required this.storyRepository,
  });

  final AuthViewModel authViewModel;
  final LocaleViewModel localeViewModel;
  final StoryListViewModel storyListViewModel;
  final StoryRepository storyRepository;

  @override
  State<StoryBloomApp> createState() => _StoryBloomAppState();
}

class _StoryBloomAppState extends State<StoryBloomApp> {
  late final _router = AppRouter.createRouter(
    authViewModel: widget.authViewModel,
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(
          value: widget.authViewModel,
        ),
        ChangeNotifierProvider<LocaleViewModel>.value(
          value: widget.localeViewModel,
        ),
        ChangeNotifierProvider<StoryListViewModel>.value(
          value: widget.storyListViewModel,
        ),
        Provider<StoryRepository>.value(value: widget.storyRepository),
      ],
      child: Consumer<LocaleViewModel>(
        builder:
            (
              BuildContext context,
              LocaleViewModel localeViewModel,
              Widget? child,
            ) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                onGenerateTitle: (BuildContext context) =>
                    AppLocalizations.of(context)!.appName,
                theme: AppTheme.lightTheme,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: localeViewModel.locale,
                routerConfig: _router,
              );
            },
      ),
    );
  }
}
