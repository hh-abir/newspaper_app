import 'package:dartz/dartz.dart';
import 'package:newspaper_app/core/error/failures.dart';
import 'package:newspaper_app/features/article/domain/entities/article.dart';
import 'package:newspaper_app/features/article/domain/repositories/article_repository.dart';

class GetArticleById {
  final ArticleRepository repository;

  GetArticleById({required this.repository});

  Future<Either<Failure, Article>> call(int id) {
    return repository.getArticleById(id);
  }
}
