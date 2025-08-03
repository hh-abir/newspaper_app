import 'package:newspaper_app/core/error/exceptions.dart';
import 'package:newspaper_app/features/article/data/models/article_model.dart';
import 'package:dio/dio.dart';

abstract class ArticleRemoteDataSource {
  Future<List<ArticleModel>> getArticles();
  Future<ArticleModel> getArticleById(int id);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final Dio dio;

  ArticleRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ArticleModel>> getArticles() async {
    try {
      final response = await dio.get("/posts");

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = response.data;
        return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: "Failed to load articles",
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: "Failed to load articles: ${e.message}",
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(
        message: "An unexpected error occurred ${e.toString()}",
        statusCode: 500,
      );
    }
  }

  @override
  Future<ArticleModel> getArticleById(int id) async {
    try {
      final response = await dio.get("/posts/$id");

      if (response.statusCode == 200) {
        return ArticleModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: "Failed to load article",
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: "Failed to load article: ${e.message}",
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw ServerException(
        message: "An unexpected error occurred ${e.toString()}",
        statusCode: 500,
      );
    }
  }
}
