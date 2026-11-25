import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Proyek portofolio yang disinkronkan dengan API Django REST Framework.
///
/// Field mengikuti ProjectSerializer: id, title, description, category,
/// thumbnail, project_url. (star_count dkk. diabaikan.)
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.projectUrl,
    this.thumbnail = '',
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// UUID dari server, tidak ikut dikirim saat POST.
  @JsonKey(includeToJson: false)
  final String? id;

  final String title;
  final String description;

  @JsonKey(defaultValue: '')
  final String category;

  @JsonKey(defaultValue: '')
  final String projectUrl;

  @JsonKey(defaultValue: '')
  final String thumbnail;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}