import 'package:go_router/go_router.dart';
import 'package:movieapp/features/movies/presentation/screens/movie_home_page.dart';
import 'package:movieapp/features/splash/presentation/screens/splash_screen.dart';

final GoRouter routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),  
    ),
      GoRoute(
      path: '/home',
      name: 'homepage',
      builder: (context, state) => const MovieHomePage(),
    ),
  ],
);