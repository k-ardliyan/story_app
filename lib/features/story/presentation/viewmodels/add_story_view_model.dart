import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/network/app_error_mapper.dart';
import '../../data/repositories/story_repository.dart';

class AddStoryViewModel extends ChangeNotifier {
  static const String errorPhotoTooLarge = 'photo_too_large';
  static const String errorPhotoPickFailed = 'photo_pick_failed';
  static const String errorPhotoRequired = 'photo_required';
  static const String errorDescriptionRequired = 'description_required';

  AddStoryViewModel({
    required StoryRepository storyRepository,
    required bool locationEnabled,
    ImagePicker? imagePicker,
  }) : _storyRepository = storyRepository,
       _locationEnabled = locationEnabled,
       _imagePicker = imagePicker ?? ImagePicker();

  final StoryRepository _storyRepository;
  final bool _locationEnabled;
  final ImagePicker _imagePicker;
  static const int _maxImageBytes = 1024 * 1024;

  XFile? _selectedImage;
  double? _selectedLatitude;
  double? _selectedLongitude;
  String? _selectedAddress;
  bool _isSubmitting = false;
  String? _errorMessage;

  XFile? get selectedImage => _selectedImage;
  bool get isLocationEnabled => _locationEnabled;
  bool get hasLocationSelection =>
      _selectedLatitude != null && _selectedLongitude != null;
  double? get selectedLatitude => _selectedLatitude;
  double? get selectedLongitude => _selectedLongitude;
  String? get selectedAddress => _selectedAddress;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  void setLocation({
    required double latitude,
    required double longitude,
    required String address,
  }) {
    _selectedLatitude = latitude;
    _selectedLongitude = longitude;
    _selectedAddress = address;
    notifyListeners();
  }

  void clearLocation() {
    _selectedLatitude = null;
    _selectedLongitude = null;
    _selectedAddress = null;
    notifyListeners();
  }

  Future<bool> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1280,
      );

      if (image == null) {
        return false;
      }

      final int sizeInBytes = await image.length();
      if (sizeInBytes > _maxImageBytes) {
        _errorMessage = errorPhotoTooLarge;
        notifyListeners();
        return false;
      }

      _selectedImage = image;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = errorPhotoPickFailed;
      notifyListeners();
      return false;
    }
  }

  Future<bool> submit({required String description}) async {
    final String cleanDescription = description.trim();

    if (cleanDescription.isEmpty) {
      _errorMessage = errorDescriptionRequired;
      notifyListeners();
      return false;
    }

    if (_selectedImage == null) {
      _errorMessage = errorPhotoRequired;
      notifyListeners();
      return false;
    }

    final int selectedImageSize = await _selectedImage!.length();
    if (selectedImageSize > _maxImageBytes) {
      _errorMessage = errorPhotoTooLarge;
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _storyRepository.addStory(
        description: cleanDescription,
        photoPath: _selectedImage!.path,
        lat: _locationEnabled ? _selectedLatitude : null,
        lon: _locationEnabled ? _selectedLongitude : null,
      );
      return true;
    } catch (error) {
      _errorMessage = _parseError(error);
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  String _parseError(Object error) {
    return AppErrorMapper.toCode(error);
  }
}
