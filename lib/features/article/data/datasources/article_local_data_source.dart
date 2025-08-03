import 'dart:convert';

import 'package:newspaper_app/core/error/exceptions.dart';
import 'package:newspaper_app/features/article/data/models/article_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ArticleLocalDataSource {
  Future<List<ArticleModel>> getCachedArticles();
  Future<void> cacheArticles(List<ArticleModel> articles);
  Future<void> clearCache();
}

class ArtcleLocalDataSourceImpl implements ArticleLocalDataSource {
  final SharedPreferences sharedPreferences;

  ArtcleLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ArticleModel>> getCachedArticles() async {
    final jsonString = sharedPreferences.getString('CACHED_ARTICLES');
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => ArticleModel.fromJson(json)).toList();
      } catch (e) {
        throw CacheException(
          message: "Failed to parse cached articles: ${e.toString()}",
        );
      }
    } else {
      throw CacheException(message: "No cached articles found");
    }
  }

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) {
    final List<Map<String, dynamic>> jsonList = articles
        .map((article) => article.toJson())
        .toList();
    final jsonString = json.encode(jsonList);
    return sharedPreferences.setString('CACHED_ARTICLES', jsonString);
  }

  @override
  Future<void> clearCache() {
    return sharedPreferences.remove('CACHED_ARTICLES');
  }
}
