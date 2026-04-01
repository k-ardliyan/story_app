import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/viewmodels/locale_view_model.dart';
import 'core/storage/app_settings_storage.dart';
import 'core/storage/session_storage.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/data/services/auth_api_service.dart';
import 'features/auth/presentation/viewmodels/auth_view_model.dart';
import 'features/story/data/repositories/story_repository.dart';
import 'features/story/data/services/story_api_service.dart';
import 'features/story/presentation/viewmodels/story_list_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final sessionStorage = SessionStorage(preferences);
  final appSettingsStorage = AppSettingsStorage(preferences);

  final authApiService = AuthApiService(http.Client());
  final storyApiService = StoryApiService(http.Client());

  final authRepository = AuthRepository(
    authApiService: authApiService,
    sessionStorage: sessionStorage,
  );
  final storyRepository = StoryRepository(
    storyApiService: storyApiService,
    sessionStorage: sessionStorage,
  );

  final authViewModel = AuthViewModel(authRepository: authRepository);
  final localeViewModel = LocaleViewModel(settingsStorage: appSettingsStorage);
  final storyListViewModel = StoryListViewModel(
    storyRepository: storyRepository,
  );

  await authViewModel.restoreSession();
  await localeViewModel.restoreLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
        ChangeNotifierProvider<LocaleViewModel>.value(value: localeViewModel),
        ChangeNotifierProvider<StoryListViewModel>.value(
          value: storyListViewModel,
        ),
        Provider<StoryRepository>.value(value: storyRepository),
      ],
      child: const StoryBloomApp(),
    ),
  );
}
