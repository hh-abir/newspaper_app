import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newspaper_app/features/article/presentation/providers/article_provider.dart';
import 'package:newspaper_app/features/article/presentation/widgets/article_card.dart';
import 'package:newspaper_app/features/article/presentation/widgets/shimmer_loading.dart';
import 'package:newspaper_app/service_locator.dart';

class ArticleListPage extends ConsumerStatefulWidget {
  const ArticleListPage({super.key});

  @override
  ConsumerState<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends ConsumerState<ArticleListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch articles when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(articleNotifierProvider.notifier).fetchArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final articleState = ref.watch(articleNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Newspaper App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(articleNotifierProvider.notifier).fetchArticles();
            },
          ),
        ],
      ),
      body: _buildBody(articleState),
    );
  }

  Widget _buildBody(ArticleState state) {
    if (state.isLoading) {
      return const ShimmerLoading();
    } else if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(articleNotifierProvider.notifier).fetchArticles();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (state.articles != null) {
      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(articleNotifierProvider.notifier).fetchArticles();
        },
        child: ListView.builder(
          itemCount: state.articles!.length,
          itemBuilder: (context, index) {
            final article = state.articles![index];
            return ArticleCard(
              article: article,
              onTap: () {
                context.push('/article/${article.id}');
              },
            );
          },
        ),
      );
    } else {
      return const Center(child: Text('No articles found'));
    }
  }
}
