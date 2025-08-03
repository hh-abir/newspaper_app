import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newspaper_app/config/routes.dart';
import 'package:newspaper_app/config/themes.dart';
import 'package:newspaper_app/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create a provider container
  final container = ProviderContainer();

  // Initialize the dependencies
  final articleNotifier = await container.read(
    initializedArticleNotifierProvider.future,
  );

  runApp(
    ProviderScope(
      overrides: [
        articleNotifierProvider.overrideWith((ref) => articleNotifier),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Newspaper App',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
