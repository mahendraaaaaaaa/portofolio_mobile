// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
  id: json['id'] as String?,
  title: json['title'] as String,
  description: json['description'] as String,
  category: json['category'] as String? ?? '',
  projectUrl: json['project_url'] as String? ?? '',
  thumbnail: json['thumbnail'] as String? ?? '',
);

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'project_url': instance.projectUrl,
  'thumbnail': instance.thumbnail,
};
