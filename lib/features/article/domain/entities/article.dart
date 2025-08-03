import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String body;
  final String? imageUrl;

  const Article({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, userId, title, body, imageUrl];
}
