import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newspaper_app/core/error/failures.dart';
import 'package:newspaper_app/features/article/domain/entities/article.dart';
import 'package:newspaper_app/features/article/domain/usecases/get_article_by_id.dart';
import 'package:newspaper_app/features/article/domain/usecases/get_articles.dart';

class ArticleNotifier extends StateNotifier<ArticleState> {
  final GetArticles getArticles;
  final GetArticleById getArticleById;

  ArticleNotifier({required this.getArticles, required this.getArticleById})
    : super(const ArticleState.initial());

  Future<void> fetchArticles() async {
    state = const ArticleState.loading();

    final failureOrArticles = await getArticles();
    state = failureOrArticles.fold(
      (failure) => ArticleState.error(_mapFailureToMessage(failure)),
      (articles) => ArticleState.loaded(articles),
    );
  }

  Future<void> fetchArticleById(int id) async {
    state = const ArticleState.loading();

    final failureOrArticle = await getArticleById(id);
    state = failureOrArticle.fold(
      (failure) => ArticleState.error(_mapFailureToMessage(failure)),
      (article) => ArticleState.loadedSingle(article),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return 'Network failure occurred: ${failure.message}';
      case ServerFailure _:
        return 'Server failure occurred: ${failure.message}';
      case CacheFailure _:
        return 'Cache failure occurred: ${failure.message}';
      default:
        return 'Unexpected error occurred';
    }
  }
}

class ArticleState {
  final List<Article>? articles;
  final Article? article;
  final bool isLoading;
  final String? errorMessage;

  const ArticleState({
    this.articles,
    this.article,
    this.isLoading = false,
    this.errorMessage,
  });

  const ArticleState.initial()
    : articles = null,
      article = null,
      isLoading = false,
      errorMessage = null;

  const ArticleState.loading()
    : articles = null,
      article = null,
      isLoading = true,
      errorMessage = null;

  const ArticleState.loaded(List<Article> this.articles)
    : article = null,
      isLoading = false,
      errorMessage = null;
  const ArticleState.loadedSingle(Article this.article)
    : articles = null,
      isLoading = false,
      errorMessage = null;

  const ArticleState.error(String this.errorMessage)
    : articles = null,
      article = null,
      isLoading = false;
}
