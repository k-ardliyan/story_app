import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/l10n/app_localizations.dart';

import '../core/theme/app_theme.dart';
import 'viewmodels/locale_view_model.dart';
import '../features/auth/presentation/viewmodels/auth_view_model.dart';
import 'router.dart';

class StoryBloomApp extends StatefulWidget {
  const StoryBloomApp({super.key});

  @override
  State<StoryBloomApp> createState() => _StoryBloomAppState();
}

class _StoryBloomAppState extends State<StoryBloomApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(
      authViewModel: context.read<AuthViewModel>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleViewModel>(
      builder:
          (BuildContext context, LocaleViewModel localeViewModel, Widget? _) {
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
    );
  }
}
