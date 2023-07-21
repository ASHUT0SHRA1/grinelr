import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grinler/common/loading_page.dart';
import 'package:grinler/features/auth/controllers/auth_controller.dart';
import 'package:grinler/features/auth/view/landing_page.dart';
import 'package:grinler/features/home/view/home_view.dart';
import 'package:grinler/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// MyApp widget, responsible for initializing the app
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grinler',
      theme: AppTheme.theme,
      home: const AuthCheck(),
    );
  }
}

// AuthCheck widget, responsible for determining whether to show HomeView or LandingPage
class AuthCheck extends ConsumerWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserAccountProvider).value;

    if (currentUser != null) {
      return const HomeView(); // Pass the currentUser object
    } else if (ref.watch(currentUserAccountProvider).isLoading) {
      return const LoadingPage();
    } else {
      return const LandingPage();
    }
  }
}
