import 'package:newspaper_app/core/error/exceptions.dart';
import 'package:newspaper_app/core/error/failures.dart';
import 'package:newspaper_app/core/network/network_info.dart';
import 'package:newspaper_app/features/article/data/datasources/article_local_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:newspaper_app/features/article/data/datasources/article_remote_data_source.dart';
import 'package:newspaper_app/features/article/data/models/article_model.dart';
import 'package:newspaper_app/features/article/domain/entities/article.dart';
import 'package:newspaper_app/features/article/domain/repositories/article_repository.dart';

class ArticleRepositoryImp implements ArticleRepository {
  final ArticleRemoteDataSource remoteDataSource;
  final ArticleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ArticleRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Article>>> getArticles() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticles = await remoteDataSource.getArticles();
        await localDataSource.cacheArticles(remoteArticles);
        return Right(remoteArticles.map((model) => _toEntity(model)).toList());
      } on ServerException catch (e) {
        return Left(
          ServerFailure(
            message: "Failed to fetch articles from server: ${e.message}",
          ),
        );
      }
    } else {
      try {
        final cachedArticles = await localDataSource.getCachedArticles();
        return Right(cachedArticles.map((model) => _toEntity(model)).toList());
      } on CacheException catch (e) {
        return Left(
          CacheFailure(message: "No cached articles found: ${e.message}"),
        );
      }
    }
  }

  @override
  Future<Either<Failure, Article>> getArticleById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticle = await remoteDataSource.getArticleById(id);
        return Right(_toEntity(remoteArticle));
      } on ServerException {
        return Left(
          ServerFailure(message: 'Failed to fetch article from server'),
        );
      }
    } else {
      try {
        final localArticles = await localDataSource.getCachedArticles();
        final article = localArticles.where((a) => a.id == id).firstOrNull;

        if (article != null) {
          return Right(_toEntity(article));
        } else {
          return Left(CacheFailure(message: 'Article not found in cache'));
        }
      } on CacheException {
        return Left(CacheFailure(message: 'No cached articles available'));
      }
    }
  }

  Article _toEntity(ArticleModel model) {
    return Article(
      id: model.id,
      userId: model.userId,
      title: model.title,
      body: model.body,
      imageUrl:
          model.imageUrl ??
          'https://picsum.photos/seed/${model.id}/800/600.jpg',
    );
  }
}
