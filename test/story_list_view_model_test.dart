import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:story_app/features/story/data/models/story_item.dart';
import 'package:story_app/features/story/data/repositories/story_repository.dart';
import 'package:story_app/features/story/presentation/viewmodels/story_list_view_model.dart';

class MockStoryRepository extends Mock implements StoryRepository {}

void main() {
  group('StoryListViewModel', () {
    late MockStoryRepository repository;
    late StoryListViewModel viewModel;

    setUp(() {
      repository = MockStoryRepository();
      viewModel = StoryListViewModel(storyRepository: repository);
    });

    test('fetchStories loads first page', () async {
      when(
        () => repository.getStories(page: 1, size: 10),
      ).thenAnswer((_) async => _buildStories(prefix: 'page-1', count: 10));

      await viewModel.fetchStories();

      expect(viewModel.errorMessage, isNull);
      expect(viewModel.stories.length, 10);
      expect(viewModel.hasMore, isTrue);
      verify(() => repository.getStories(page: 1, size: 10)).called(1);
    });

    test('fetchMoreStories appends new unique stories only', () async {
      when(
        () => repository.getStories(page: 1, size: 10),
      ).thenAnswer((_) async => _buildStories(prefix: 'first', count: 10));
      when(() => repository.getStories(page: 2, size: 10)).thenAnswer(
        (_) async => <StoryItem>[
          _buildStory('first-0'),
          _buildStory('second-1'),
        ],
      );

      await viewModel.fetchStories();
      await viewModel.fetchMoreStories();

      expect(viewModel.stories.length, 11);
      expect(viewModel.hasMore, isFalse);
      expect(viewModel.paginationErrorMessage, isNull);
      verify(() => repository.getStories(page: 1, size: 10)).called(1);
      verify(() => repository.getStories(page: 2, size: 10)).called(1);
    });
  });
}

List<StoryItem> _buildStories({required String prefix, required int count}) {
  return List<StoryItem>.generate(
    count,
    (int index) => _buildStory('$prefix-$index'),
  );
}

StoryItem _buildStory(String id) {
  return StoryItem(
    id: id,
    name: 'name-$id',
    description: 'description-$id',
    photoUrl: 'https://example.com/$id.png',
    createdAt: DateTime.parse('2026-04-02T00:00:00.000Z'),
  );
}
