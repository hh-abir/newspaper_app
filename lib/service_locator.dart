import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:newspaper_app/core/constants/api_constants.dart';
import 'package:newspaper_app/core/network/network_info.dart';
import 'package:newspaper_app/features/article/data/datasources/article_local_data_source.dart';
import 'package:newspaper_app/features/article/data/datasources/article_remote_data_source.dart';
import 'package:newspaper_app/features/article/domain/repositories/article_repository.dart';
import 'package:newspaper_app/features/article/domain/repositories/article_repository_imp.dart';
import 'package:newspaper_app/features/article/domain/usecases/get_article_by_id.dart';
import 'package:newspaper_app/features/article/domain/usecases/get_articles.dart';
import 'package:newspaper_app/features/article/presentation/providers/article_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: ApiConstants.connectionTimeout),
      receiveTimeout: const Duration(seconds: ApiConstants.receiveTimeout),
    ),
  );
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

final networkInfoProvider = FutureProvider<NetworkInfo>((ref) async {
  final connectionChecker = InternetConnectionChecker.createInstance();
  return NetworkInfoImpl(connectionChecker: connectionChecker);
});

final articleRemoteDataSourceProvider = FutureProvider<ArticleRemoteDataSource>(
  (ref) async {
    final dio = ref.read(dioProvider);
    return ArticleRemoteDataSourceImpl(dio: dio);
  },
);

final articleLocalDataSourceProvider = FutureProvider<ArticleLocalDataSource>((
  ref,
) async {
  final prefs = await ref.read(sharedPreferencesProvider.future);
  return ArtcleLocalDataSourceImpl(sharedPreferences: prefs);
});

// Repository provider
final articleRepositoryProvider = FutureProvider<ArticleRepository>((
  ref,
) async {
  final remoteDataSource = await ref.read(
    articleRemoteDataSourceProvider.future,
  );
  final localDataSource = await ref.read(articleLocalDataSourceProvider.future);
  final networkInfo = await ref.read(networkInfoProvider.future);

  return ArticleRepositoryImp(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});

// Use cases providers
final getArticlesProvider = FutureProvider<GetArticles>((ref) async {
  final repository = await ref.read(articleRepositoryProvider.future);
  return GetArticles(repository: repository);
});

final getArticleByIdProvider = FutureProvider<GetArticleById>((ref) async {
  final repository = await ref.read(articleRepositoryProvider.future);
  return GetArticleById(repository: repository);
});

// Notifier provider
final articleNotifierProvider =
    StateNotifierProvider<ArticleNotifier, ArticleState>((ref) {
      // We'll handle the async initialization in main.dart
      throw UnimplementedError('Provider not initialized');
    });

// Provider to initialize the notifier when dependencies are ready
final initializedArticleNotifierProvider = FutureProvider<ArticleNotifier>((
  ref,
) async {
  final getArticles = await ref.read(getArticlesProvider.future);
  final getArticleById = await ref.read(getArticleByIdProvider.future);

  return ArticleNotifier(
    getArticles: getArticles,
    getArticleById: getArticleById,
  );
});
