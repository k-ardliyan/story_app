import 'package:flutter_test/flutter_test.dart';
import 'package:story_app/features/story/data/models/story_item.dart';

void main() {
  test('StoryItem.fromJson parses values correctly', () {
    final StoryItem item = StoryItem.fromJson(<String, dynamic>{
      'id': 'story-1',
      'name': 'Dicoding User',
      'description': 'Belajar Flutter',
      'photoUrl': 'https://example.com/photo.png',
      'createdAt': '2026-04-01T10:30:00.000Z',
      'lat': -6.2,
      'lon': 106.8,
    });

    expect(item.id, 'story-1');
    expect(item.name, 'Dicoding User');
    expect(item.description, 'Belajar Flutter');
    expect(item.photoUrl, 'https://example.com/photo.png');
    expect(
      item.createdAt.toUtc().toIso8601String(),
      '2026-04-01T10:30:00.000Z',
    );
    expect(item.lat, -6.2);
    expect(item.lon, 106.8);
  });
}
