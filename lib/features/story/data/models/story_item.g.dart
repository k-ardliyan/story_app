// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoryItemImpl _$$StoryItemImplFromJson(Map<String, dynamic> json) =>
    _$StoryItemImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '-',
      description: json['description'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? '',
      createdAt: const StoryDateTimeConverter().fromJson(json['createdAt']),
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$StoryItemImplToJson(_$StoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'createdAt': const StoryDateTimeConverter().toJson(instance.createdAt),
      'lat': instance.lat,
      'lon': instance.lon,
    };
