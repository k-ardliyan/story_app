// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'StoryBloom';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle =>
      'Login to continue sharing your learning stories.';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Join StoryBloom and start sharing today.';

  @override
  String get nameLabel => 'Name';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get registerButton => 'Register';

  @override
  String get goToRegister => 'Don\'t have an account? Register';

  @override
  String get goToLogin => 'Already have an account? Login';

  @override
  String get homeTitle => 'Story Feed';

  @override
  String get addStoryTitle => 'Add Story';

  @override
  String get storyDetailTitle => 'Story Detail';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'Tell your learning moment...';

  @override
  String get photoLabel => 'Photo';

  @override
  String get photoPlaceholder => 'No photo selected yet';

  @override
  String get pickFromCamera => 'Camera';

  @override
  String get pickFromGallery => 'Gallery';

  @override
  String get uploadStoryButton => 'Upload Story';

  @override
  String get refreshTooltip => 'Refresh';

  @override
  String get showPasswordTooltip => 'Show password';

  @override
  String get hidePasswordTooltip => 'Hide password';

  @override
  String get languageButton => 'Language';

  @override
  String get languageSheetTitle => 'Choose app language';

  @override
  String get languageSheetMessage =>
      'Select your preferred language for StoryBloom.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get logoutButton => 'Logout';

  @override
  String get logoutSheetTitle => 'Leave this session?';

  @override
  String get logoutSheetMessage =>
      'You can login again anytime to continue your stories.';

  @override
  String get stayLoggedInButton => 'Stay Logged In';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get retryButton => 'Try Again';

  @override
  String get emptyStateTitle => 'No data';

  @override
  String get emptyStoriesTitle => 'No stories yet';

  @override
  String get emptyStoriesMessage =>
      'Be the first one to share your learning story.';

  @override
  String get emailRequiredError => 'Email is required';

  @override
  String get invalidEmailError => 'Email format is invalid';

  @override
  String get passwordRequiredError => 'Password is required';

  @override
  String get passwordMinError => 'Password must be at least 8 characters';

  @override
  String get nameRequiredError => 'Name is required';

  @override
  String get descriptionRequiredError => 'Description is required';

  @override
  String get photoRequiredError => 'Photo is required';

  @override
  String get photoTooLargeError => 'Photo must be less than 1MB';

  @override
  String get photoPickFailedError => 'Failed to pick photo';

  @override
  String get offlineError =>
      'No internet connection. Please check your network and try again.';

  @override
  String get requestTimeoutError =>
      'The request took too long. Please try again.';

  @override
  String get sessionExpiredError =>
      'Your session has expired. Please login again.';

  @override
  String get unauthorizedError => 'Your email or password is incorrect.';

  @override
  String get forbiddenError =>
      'You do not have permission to perform this action.';

  @override
  String get notFoundError => 'The requested data could not be found.';

  @override
  String get tooManyRequestsError =>
      'Too many attempts. Please wait a moment and try again.';

  @override
  String get serverError =>
      'The service is having issues. Please try again later.';

  @override
  String get badRequestError =>
      'The submitted data is invalid. Please review your input.';

  @override
  String get serviceUnavailableError =>
      'The service is currently unavailable. Please try again later.';

  @override
  String get genericError => 'An unexpected error happened.';

  @override
  String get registerSuccessMessage => 'Registration success. Please login.';

  @override
  String get uploadSuccessMessage => 'Story uploaded successfully.';

  @override
  String get locationLabel => 'Location';

  @override
  String get locationPickerTitle => 'Pick Location';

  @override
  String get saveLocationButton => 'Save';

  @override
  String get mapTapInstruction =>
      'Tap the map or use your current GPS location.';

  @override
  String get locationNotSelectedMessage => 'No location selected.';

  @override
  String selectedCoordinatesLabel(String latitude, String longitude) {
    return 'Coordinates: $latitude, $longitude';
  }

  @override
  String get unknownAddressLabel => 'Address unavailable';

  @override
  String get pickLocationFromMapButton => 'Choose Location';

  @override
  String get changeLocationButton => 'Change Location';

  @override
  String get clearLocationButton => 'Clear Location';

  @override
  String get locationDisabledInFreeMessage =>
      'Location pin is currently unavailable in FREE mode.';

  @override
  String get paidFlavorBadge => 'PAID';

  @override
  String get freeFlavorBadge => 'FREE';

  @override
  String get locationEnabledForPaidTitle => 'PAID mode is active';

  @override
  String get locationEnabledForPaidDescription =>
      'You can pin location from map or GPS for this story.';

  @override
  String get locationLockedForFreeTitle => 'FREE mode is active';

  @override
  String get locationLockedForFreeDescription =>
      'Location pin is still locked in this mode.';

  @override
  String get modeDifferenceSheetTitle =>
      'What\'s different between FREE and PAID?';

  @override
  String get modeDifferenceFreeTitle => 'FREE';

  @override
  String get modeDifferenceFreeDescription =>
      'You can post stories with photo and description.';

  @override
  String get modeDifferencePaidTitle => 'PAID';

  @override
  String get modeDifferencePaidDescription =>
      'All FREE features plus map/GPS location pin for stories.';

  @override
  String get locationModeReadySummary => 'Location feature is active';

  @override
  String get locationModeLockedSummary => 'Location feature is locked';

  @override
  String get locationModeTapHint => 'Tap to view details';

  @override
  String get seeModeDifferenceButton => 'See feature differences';

  @override
  String get selectedLocationPreviewTitle => 'Selected Location Preview';

  @override
  String get useMyLocationButton => 'Use My Current Location';

  @override
  String get findingMyLocationLabel => 'Finding your location...';

  @override
  String get locationServiceDisabledMessage =>
      'Please enable location service first.';

  @override
  String get locationPermissionDeniedMessage =>
      'Location permission is required to use GPS.';

  @override
  String get locationPermissionDeniedForeverMessage =>
      'Location permission is blocked. Please enable it from app settings.';

  @override
  String get failedToGetCurrentLocationMessage =>
      'Failed to get your current location. Please try again.';

  @override
  String get retryLoadMoreStoriesButton => 'Retry loading more';

  @override
  String get noMoreStoriesMessage => 'No more stories.';

  @override
  String get markerInfoTitle => 'Location Detail';

  @override
  String get detailLoadingMessage => 'Loading story detail...';

  @override
  String get openStoryHint => 'Double tap to open story details';

  @override
  String get imageUnavailableLabel => 'Image unavailable';

  @override
  String storyImageSemanticLabel(String authorName) {
    return 'Story photo by $authorName';
  }

  @override
  String storyCardSemanticLabel(String authorName, String createdAt) {
    return '$authorName, posted on $createdAt';
  }
}
