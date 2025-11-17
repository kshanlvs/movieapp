import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movieapp/core/config/environment.dart';
import 'package:movieapp/core/config/environment_detector.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/font_size_constants.dart';
import 'package:movieapp/core/constants/text_style_constants.dart';

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
  await dotenv.load();
  ServiceLocator.init();

  final environmentDetector = EnvironmentDetector();
  final environment = environmentDetector.environment;

  final appEnv = AppEnvironment();
  appEnv.setEnvironment(environment);

  runApp(const ScreenUtilWrapper());
}

class ScreenUtilWrapper extends StatelessWidget {
  const ScreenUtilWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // your design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => const MovieApp(),
    );
  }
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
        BlocProvider(create: (context) => sl<SearchBloc>()),
      ],
      child: MaterialApp.router(
        routerConfig: routerConfig,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.redAccent,
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleTextStyle: TextStyles.appBarTitle,
            iconTheme: IconThemeData(color: AppColors.textPrimary),
          ),
          textTheme: const TextTheme(
            // Headline Text Styles
            headlineLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: FontSizes.headlineLarge,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              color: AppColors.textPrimary,
              fontSize: FontSizes.headlineMedium,
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: TextStyle(
              color: AppColors.textPrimary,
              fontSize: FontSizes.headlineSmall,
              fontWeight: FontWeight.bold,
            ),

            // Title Text Styles
            titleLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: FontSizes.titleLarge,
              fontWeight: FontWeight.w600,
            ),
            titleMedium: TextStyle(
              color: AppColors.textPrimary,
              fontSize: FontSizes.titleMedium,
              fontWeight: FontWeight.w600,
            ),
            titleSmall: TextStyle(
              color: AppColors.textPrimary,
              fontSize: FontSizes.titleSmall,
              fontWeight: FontWeight.w600,
            ),

            // Body Text Styles
            bodyLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: FontSizes.bodyLarge,
              fontWeight: FontWeight.normal,
            ),
            bodyMedium: TextStyle(
              color: AppColors.textPrimary,
              fontSize: FontSizes.bodyMedium,
              fontWeight: FontWeight.normal,
            ),
            bodySmall: TextStyle(
              color: AppColors.textSecondary,
              fontSize: FontSizes.bodySmall,
              fontWeight: FontWeight.normal,
            ),

            // Label Text Styles
            labelLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: FontSizes.labelLarge,
              fontWeight: FontWeight.w500,
            ),
            labelMedium: TextStyle(
              color: AppColors.textPrimary,
              fontSize: FontSizes.labelMedium,
              fontWeight: FontWeight.w500,
            ),
            labelSmall: TextStyle(
              color: AppColors.textSecondary,
              fontSize: FontSizes.labelSmall,
              fontWeight: FontWeight.w500,
            ),

            // Display Text Styles
            displayLarge: TextStyle(
              color: AppColors.textPrimary,
              fontSize: FontSizes.displayLarge,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: TextStyle(
              color: AppColors.textPrimary,
              fontSize: FontSizes.displayMedium,
              fontWeight: FontWeight.bold,
            ),
            displaySmall: TextStyle(
              color: AppColors.textPrimary,
              fontSize: FontSizes.displaySmall,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Button Theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
              textStyle: TextStyles.primaryButton,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Input Decoration Theme
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surfaceVariant,
            hintStyle: TextStyles.searchBarHintText,
            labelStyle: const TextStyle(color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          // Card Theme
          cardTheme: CardThemeData(
            color: AppColors.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.outline),
            ),
          ),
          // Dialog Theme
          dialogTheme: DialogThemeData(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titleTextStyle: TextStyles.movieItemTitle,
            contentTextStyle: TextStyles.movieItemOverview,
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
