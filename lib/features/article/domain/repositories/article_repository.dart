import 'package:newspaper_app/core/error/failures.dart';
import 'package:newspaper_app/features/article/domain/entities/article.dart';
import 'package:dartz/dartz.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<Article>>> getArticles();
  Future<Either<Failure, Article>> getArticleById(int id);
}
