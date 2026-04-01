import 'package:flutter/foundation.dart';

import '../../data/models/story_item.dart';
import '../../data/repositories/story_repository.dart';

class StoryListViewModel extends ChangeNotifier {
  StoryListViewModel({required StoryRepository storyRepository})
    : _storyRepository = storyRepository;

  final StoryRepository _storyRepository;

  List<StoryItem> _stories = <StoryItem>[];
  bool _isLoading = false;
  bool _isLoaded = false;
  String? _errorMessage;

  List<StoryItem> get stories => _stories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchStories({bool forceRefresh = false}) async {
    if (_isLoading) {
      return;
    }

    if (_isLoaded && !forceRefresh) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stories = await _storyRepository.getStories();
      _isLoaded = true;
    } catch (error) {
      _errorMessage = _parseError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => fetchStories(forceRefresh: true);

  void clear() {
    _stories = <StoryItem>[];
    _errorMessage = null;
    _isLoaded = false;
    notifyListeners();
  }

  String _parseError(Object error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'Unknown error happened.';
  }
}
