import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newspaper_app/features/article/presentation/providers/article_provider.dart';
import 'package:newspaper_app/service_locator.dart';

class ArticleDetailPage extends ConsumerStatefulWidget {
  final int articleId;

  const ArticleDetailPage({super.key, required this.articleId});

  @override
  ConsumerState<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends ConsumerState<ArticleDetailPage> {
  @override
  void initState() {
    super.initState();
    // Fetch the article when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(articleNotifierProvider.notifier)
          .fetchArticleById(widget.articleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final articleState = ref.watch(articleNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Article Details')),
      body: _buildBody(articleState),
    );
  }

  Widget _buildBody(ArticleState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Retry fetching the article
                ref
                    .read(articleNotifierProvider.notifier)
                    .fetchArticleById(widget.articleId);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (state.article != null) {
      final article = state.article!;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                article.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(article.body, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    } else {
      return const Center(child: Text('Article not found'));
    }
  }
}
