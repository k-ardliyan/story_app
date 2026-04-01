import '../../../../core/network/app_error_codes.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/session_storage.dart';
import '../models/story_item.dart';
import '../services/story_api_service.dart';

class StoryRepository {
  StoryRepository({
    required StoryApiService storyApiService,
    required SessionStorage sessionStorage,
  }) : _storyApiService = storyApiService,
       _sessionStorage = sessionStorage;

  final StoryApiService _storyApiService;
  final SessionStorage _sessionStorage;

  Future<List<StoryItem>> getStories() {
    final String token = _requireToken();
    return _storyApiService.fetchStories(token: token);
  }

  Future<StoryItem> getStoryDetail(String storyId) {
    final String token = _requireToken();
    return _storyApiService.fetchStoryDetail(token: token, storyId: storyId);
  }

  Future<void> addStory({
    required String description,
    required String photoPath,
    double? lat,
    double? lon,
  }) {
    final String token = _requireToken();
    return _storyApiService.addStory(
      token: token,
      description: description,
      photoPath: photoPath,
      lat: lat,
      lon: lon,
    );
  }

  String _requireToken() {
    final String? token = _sessionStorage.token;
    if (token == null || token.isEmpty) {
      throw ApiException(AppErrorCodes.sessionExpired);
    }
    return token;
  }
}
