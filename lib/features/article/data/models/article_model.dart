import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

@JsonSerializable()
class ArticleModel {
  final int id;
  final int userId;
  final String title;
  final String body;
  final String? imageUrl;

  ArticleModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.imageUrl,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);
}
