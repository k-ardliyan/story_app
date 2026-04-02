import 'package:flutter/foundation.dart';

import '../../../../core/network/app_error_mapper.dart';
import '../../data/models/story_item.dart';
import '../../data/repositories/story_repository.dart';

class StoryListViewModel extends ChangeNotifier {
  static const int _pageSize = 10;

  StoryListViewModel({required StoryRepository storyRepository})
    : _storyRepository = storyRepository;

  final StoryRepository _storyRepository;

  final List<StoryItem> _stories = <StoryItem>[];
  final Set<String> _loadedStoryIds = <String>{};

  bool _isInitialLoading = false;
  bool _isPageLoading = false;
  bool _isLoaded = false;
  bool _hasMore = true;
  int _nextPage = 1;
  String? _errorMessage;
  String? _paginationErrorMessage;

  List<StoryItem> get stories => List<StoryItem>.unmodifiable(_stories);
  bool get isLoading => _isInitialLoading;
  bool get isLoadingMore => _isPageLoading;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  String? get paginationErrorMessage => _paginationErrorMessage;

  Future<void> fetchStories({bool forceRefresh = false}) async {
    if (_isInitialLoading || _isPageLoading) {
      return;
    }

    if (_isLoaded && !forceRefresh) {
      return;
    }

    _isInitialLoading = true;
    _errorMessage = null;
    _paginationErrorMessage = null;
    if (forceRefresh) {
      _resetPagingState(clearStories: true);
    }
    notifyListeners();

    try {
      final List<StoryItem> firstPage = await _storyRepository.getStories(
        page: 1,
        size: _pageSize,
      );

      _resetPagingState(clearStories: true);
      _appendStories(firstPage);
      _nextPage = 2;
      _hasMore = firstPage.length >= _pageSize;
      _isLoaded = true;
    } catch (error) {
      _errorMessage = _parseError(error);
    } finally {
      _isInitialLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreStories() async {
    if (_isInitialLoading || _isPageLoading || !_hasMore) {
      return;
    }

    _isPageLoading = true;
    _paginationErrorMessage = null;
    notifyListeners();

    try {
      final List<StoryItem> nextStories = await _storyRepository.getStories(
        page: _nextPage,
        size: _pageSize,
      );

      if (nextStories.isEmpty) {
        _hasMore = false;
        return;
      }

      _appendStories(nextStories);
      _nextPage += 1;

      if (nextStories.length < _pageSize) {
        _hasMore = false;
      }
    } catch (error) {
      _paginationErrorMessage = _parseError(error);
    } finally {
      _isPageLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => fetchStories(forceRefresh: true);

  void clear() {
    _resetPagingState(clearStories: true);
    _errorMessage = null;
    _paginationErrorMessage = null;
    _isLoaded = false;
    notifyListeners();
  }

  void _appendStories(List<StoryItem> stories) {
    for (final StoryItem story in stories) {
      final String storyId = story.id;
      if (storyId.isEmpty) {
        continue;
      }

      if (_loadedStoryIds.add(storyId)) {
        _stories.add(story);
      }
    }
  }

  void _resetPagingState({required bool clearStories}) {
    if (clearStories) {
      _stories.clear();
      _loadedStoryIds.clear();
    }

    _nextPage = 1;
    _hasMore = true;
  }

  String _parseError(Object error) {
    return AppErrorMapper.toCode(error);
  }
}
