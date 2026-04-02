import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/flavor/app_flavor.dart';
import 'app/viewmodels/locale_view_model.dart';
import 'core/location/reverse_geocoding_service.dart';
import 'core/storage/app_settings_storage.dart';
import 'core/storage/session_storage.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/data/services/auth_api_service.dart';
import 'features/auth/presentation/viewmodels/auth_view_model.dart';
import 'features/story/data/repositories/story_repository.dart';
import 'features/story/data/services/story_api_service.dart';
import 'features/story/presentation/viewmodels/story_list_view_model.dart';

Future<void> bootstrap({AppFlavor? flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();

  const String flutterAppFlavor = String.fromEnvironment('FLUTTER_APP_FLAVOR');
  const String legacyFlavor = String.fromEnvironment('FLAVOR');
  final AppFlavor resolvedFlavor = AppFlavorConfig.resolve(
    preferred: flavor,
    flutterAppFlavor: flutterAppFlavor,
    legacyFlavor: legacyFlavor,
  );

  AppFlavorConfig.setFlavor(resolvedFlavor);

  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final SessionStorage sessionStorage = SessionStorage(preferences);
  final AppSettingsStorage appSettingsStorage = AppSettingsStorage(preferences);

  final AuthApiService authApiService = AuthApiService(http.Client());
  final StoryApiService storyApiService = StoryApiService(http.Client());
  final ReverseGeocodingService reverseGeocodingService =
      ReverseGeocodingService();

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
  final StoryListViewModel storyListViewModel = StoryListViewModel(
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
        Provider<ReverseGeocodingService>.value(value: reverseGeocodingService),
      ],
      child: const StoryBloomApp(),
    ),
  );
}
