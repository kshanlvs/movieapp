import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movieapp/core/config/environment.dart';
import 'package:movieapp/core/config/environment_detector.dart';
import 'package:movieapp/core/database/database_manager.dart';
import 'package:movieapp/core/di/service_locator.dart';
import 'package:movieapp/core/router/router_config.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:movieapp/features/movie_details/presentation/bloc/movie_detail_bloc.dart';

import 'package:movieapp/features/now_playing_movies/presentation/bloc/now_playing_movie_bloc.dart';
import 'package:movieapp/features/search/presentation/bloc/search_bloc.dart';
import 'package:movieapp/features/trending_movies/presentation/bloc/trending_movie_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    DatabaseManager.init(),
    dotenv.load(fileName: '.env'),
    ServiceLocator.init(),
  ]);

  final env = EnvironmentDetector.detectEnvironment();
  AppEnvironment.setEnvironment(env);

  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TrendingMoviesBloc>(
          create: (context) => sl<TrendingMoviesBloc>(),
        ),
        BlocProvider<NowPlayingMoviesBloc>(
          create: (context) => sl<NowPlayingMoviesBloc>(),
        ),

        BlocProvider<MovieDetailBloc>(
          create: (context) => sl<MovieDetailBloc>(),
        ),
        BlocProvider<BookmarkBloc>(
          create: (context) => sl<BookmarkBloc>()..add(LoadBookmarks()),
        ),

        BlocProvider(create:(context) => sl<SearchBloc>())
      ],
      child: MaterialApp.router(
        routerConfig: routerConfig,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.redAccent,
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
