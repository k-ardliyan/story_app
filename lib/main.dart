import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final SessionStorage sessionStorage = SessionStorage(preferences);
  final AppSettingsStorage appSettingsStorage = AppSettingsStorage(preferences);

  final AuthApiService authApiService = AuthApiService(http.Client());
  final StoryApiService storyApiService = StoryApiService(http.Client());

  final AuthRepository authRepository = AuthRepository(
    authApiService: authApiService,
    sessionStorage: sessionStorage,
  );
  final StoryRepository storyRepository = StoryRepository(
    storyApiService: storyApiService,
    sessionStorage: sessionStorage,
  );

  final AuthViewModel authViewModel = AuthViewModel(
    authRepository: authRepository,
  );
  final LocaleViewModel localeViewModel = LocaleViewModel(
    settingsStorage: appSettingsStorage,
  );

  await authViewModel.restoreSession();
  await localeViewModel.restoreLocale();

  runApp(
    StoryBloomApp(
      authViewModel: authViewModel,
      localeViewModel: localeViewModel,
      storyListViewModel: StoryListViewModel(storyRepository: storyRepository),
      storyRepository: storyRepository,
    ),
  );
}
