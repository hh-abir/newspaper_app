import 'package:dartz/dartz.dart';
import 'package:newspaper_app/core/error/failures.dart';
import 'package:newspaper_app/features/article/domain/entities/article.dart';
import 'package:newspaper_app/features/article/domain/repositories/article_repository.dart';

class GetArticles {
  final ArticleRepository repository;

  GetArticles({required this.repository});

  Future<Either<Failure, List<Article>>> call() {
    return repository.getArticles();
  }
}
