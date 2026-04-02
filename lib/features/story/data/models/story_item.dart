import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_item.freezed.dart';
part 'story_item.g.dart';

@freezed
class StoryItem with _$StoryItem {
  const StoryItem._();

  const factory StoryItem({
    @Default('') String id,
    @Default('-') String name,
    @Default('') String description,
    @Default('') String photoUrl,
    @StoryDateTimeConverter() required DateTime createdAt,
    double? lat,
    double? lon,
  }) = _StoryItem;

  factory StoryItem.fromJson(Map<String, dynamic> json) =>
      _$StoryItemFromJson(json);
}

class StoryDateTimeConverter implements JsonConverter<DateTime, Object?> {
  const StoryDateTimeConverter();

  @override
  DateTime fromJson(Object? value) {
    if (value is String) {
      final DateTime? parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  @override
  Object toJson(DateTime value) => value.toIso8601String();
}
