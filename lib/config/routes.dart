import 'package:go_router/go_router.dart';
import 'package:newspaper_app/features/article/presentation/pages/article_detail_page.dart';
import 'package:newspaper_app/features/article/presentation/pages/article_list_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ArticleListPage()),
    GoRoute(
      path: '/article/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ArticleDetailPage(articleId: id);
      },
    ),
  ],
);
