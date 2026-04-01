import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'StoryBloom'**
  String get appName;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to continue sharing your learning stories.'**
  String get loginSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join StoryBloom and start sharing today.'**
  String get registerSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @goToRegister.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get goToRegister;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get goToLogin;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Story Feed'**
  String get homeTitle;

  /// No description provided for @addStoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Story'**
  String get addStoryTitle;

  /// No description provided for @storyDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Story Detail'**
  String get storyDetailTitle;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Tell your learning moment...'**
  String get descriptionHint;

  /// No description provided for @photoLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photoLabel;

  /// No description provided for @photoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'No photo selected yet'**
  String get photoPlaceholder;

  /// No description provided for @pickFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get pickFromCamera;

  /// No description provided for @pickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get pickFromGallery;

  /// No description provided for @uploadStoryButton.
  ///
  /// In en, this message translates to:
  /// **'Upload Story'**
  String get uploadStoryButton;

  /// No description provided for @refreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshTooltip;

  /// No description provided for @showPasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPasswordTooltip;

  /// No description provided for @hidePasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePasswordTooltip;

  /// No description provided for @languageButton.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageButton;

  /// No description provided for @languageSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose app language'**
  String get languageSheetTitle;

  /// No description provided for @languageSheetMessage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language for StoryBloom.'**
  String get languageSheetMessage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageIndonesian;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// No description provided for @logoutSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave this session?'**
  String get logoutSheetTitle;

  /// No description provided for @logoutSheetMessage.
  ///
  /// In en, this message translates to:
  /// **'You can login again anytime to continue your stories.'**
  String get logoutSheetMessage;

  /// No description provided for @stayLoggedInButton.
  ///
  /// In en, this message translates to:
  /// **'Stay Logged In'**
  String get stayLoggedInButton;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get retryButton;

  /// No description provided for @emptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get emptyStateTitle;

  /// No description provided for @emptyStoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'No stories yet'**
  String get emptyStoriesTitle;

  /// No description provided for @emptyStoriesMessage.
  ///
  /// In en, this message translates to:
  /// **'Be the first one to share your learning story.'**
  String get emptyStoriesMessage;

  /// No description provided for @emailRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequiredError;

  /// No description provided for @invalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Email format is invalid'**
  String get invalidEmailError;

  /// No description provided for @passwordRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequiredError;

  /// No description provided for @passwordMinError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinError;

  /// No description provided for @nameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequiredError;

  /// No description provided for @descriptionRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequiredError;

  /// No description provided for @photoRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Photo is required'**
  String get photoRequiredError;

  /// No description provided for @photoTooLargeError.
  ///
  /// In en, this message translates to:
  /// **'Photo must be less than 1MB'**
  String get photoTooLargeError;

  /// No description provided for @photoPickFailedError.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick photo'**
  String get photoPickFailedError;

  /// No description provided for @offlineError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get offlineError;

  /// No description provided for @requestTimeoutError.
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Please try again.'**
  String get requestTimeoutError;

  /// No description provided for @sessionExpiredError.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please login again.'**
  String get sessionExpiredError;

  /// No description provided for @unauthorizedError.
  ///
  /// In en, this message translates to:
  /// **'Your email or password is incorrect.'**
  String get unauthorizedError;

  /// No description provided for @forbiddenError.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get forbiddenError;

  /// No description provided for @notFoundError.
  ///
  /// In en, this message translates to:
  /// **'The requested data could not be found.'**
  String get notFoundError;

  /// No description provided for @tooManyRequestsError.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get tooManyRequestsError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'The service is having issues. Please try again later.'**
  String get serverError;

  /// No description provided for @badRequestError.
  ///
  /// In en, this message translates to:
  /// **'The submitted data is invalid. Please review your input.'**
  String get badRequestError;

  /// No description provided for @serviceUnavailableError.
  ///
  /// In en, this message translates to:
  /// **'The service is currently unavailable. Please try again later.'**
  String get serviceUnavailableError;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error happened.'**
  String get genericError;

  /// No description provided for @registerSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Registration success. Please login.'**
  String get registerSuccessMessage;

  /// No description provided for @uploadSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Story uploaded successfully.'**
  String get uploadSuccessMessage;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @detailLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading story detail...'**
  String get detailLoadingMessage;

  /// No description provided for @openStoryHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to open story details'**
  String get openStoryHint;

  /// No description provided for @imageUnavailableLabel.
  ///
  /// In en, this message translates to:
  /// **'Image unavailable'**
  String get imageUnavailableLabel;

  /// Accessible label for a story image
  ///
  /// In en, this message translates to:
  /// **'Story photo by {authorName}'**
  String storyImageSemanticLabel(String authorName);

  /// Accessible label for a tappable story card
  ///
  /// In en, this message translates to:
  /// **'{authorName}, posted on {createdAt}'**
  String storyCardSemanticLabel(String authorName, String createdAt);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
