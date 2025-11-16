import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/route_constants.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_state.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';
import 'package:movieapp/features/movies/presentation/widgets/cached_movie_image.dart';
import 'package:movieapp/features/movies/presentation/widgets/hero_section.dart';
import 'package:movieapp/features/movies/presentation/widgets/home_page_appbar.dart';
import 'package:movieapp/features/movies/presentation/widgets/movie_list_section.dart';
import 'package:movieapp/features/now_playing_movies/presentation/bloc/now_playing_movie_bloc.dart';
import 'package:movieapp/features/now_playing_movies/presentation/bloc/now_playing_movie_event.dart';
import 'package:movieapp/features/now_playing_movies/presentation/bloc/now_playing_state.dart';
import 'package:movieapp/features/trending_movies/presentation/bloc/trending_movie_bloc.dart';
import 'package:movieapp/features/trending_movies/presentation/bloc/trending_movie_event.dart';
import 'package:movieapp/features/trending_movies/presentation/bloc/trending_movie_state.dart';

class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key});

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<TrendingMoviesBloc>().add(FetchTrendingMovies());
    context.read<NowPlayingMoviesBloc>().add(FetchNowPlayingMovies());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AnimatedAppBar(
        scrollController: _scrollController,
        onBookmarkPressed: () => context.push('/saved'),
        onSearchPressed: () {
          context.push(RouteConstants.search);
        },
      ),
      body: RefreshIndicator(
        backgroundColor: AppColors.background,
        color: AppColors.primary,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: _buildSlivers(),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<TrendingMoviesBloc>().add(FetchTrendingMovies());
    context.read<NowPlayingMoviesBloc>().add(FetchNowPlayingMovies());
    context.read<BookmarkBloc>().add(LoadBookmarks());
  }

  List<Widget> _buildSlivers() {
    return [
      BlocBuilder<TrendingMoviesBloc, TrendingMoviesState>(
        builder: (context, state) {
          return HeroSection(
            movie: state.movies.isNotEmpty ? state.movies.first : null,
            isLoading: state.isLoading && state.movies.isEmpty,
          );
        },
      ),

      _buildSectionHeader(
        AppTexts.yourBookmarks,
        onSeeAll: () => context.push('/saved'),
      ),
      BlocBuilder<BookmarkBloc, BookmarkState>(
        builder: (context, state) {
          return _buildBookmarkedSection(state);
        },
      ),

      _buildSectionHeader(AppTexts.trendingNow),
      BlocBuilder<TrendingMoviesBloc, TrendingMoviesState>(
        builder: (context, state) {
          return MovieListSection(
            movies: state.movies,
            isLoading: state.isLoading,
            error: state.error,
            onRetry: () =>
                context.read<TrendingMoviesBloc>().add(FetchTrendingMovies()),
          );
        },
      ),

      _buildSectionHeader(AppTexts.nowPlaying),
      BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
        builder: (context, state) {
          return MovieListSection(
            movies: state.movies,
            isLoading: state.isLoading,
            error: state.error,
            onRetry: () => context.read<NowPlayingMoviesBloc>().add(
              FetchNowPlayingMovies(),
            ),
          );
        },
      ),

      const SliverToBoxAdapter(
        child: SizedBox(height: SizeConstants.spaceXXXXL),
      ),
    ];
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        SizeConstants.pagePadding,
        SizeConstants.spaceXXL,
        SizeConstants.pagePadding,
        SizeConstants.spaceS,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (onSeeAll != null)
              TextButton(
                onPressed: onSeeAll,
                child: const Text(
                  AppTexts.seeAll,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkedSection(BookmarkState state) {
    return switch (state) {
      BookmarkInitial() => _buildBookmarkedLoading(),
      BookmarkLoading() => _buildBookmarkedLoading(),
      BookmarkLoaded(:final bookmarks) => _buildBookmarkedMovies(bookmarks),
      BookmarkUpdated(:final bookmarks) => _buildBookmarkedMovies(bookmarks),
      BookmarkStatusChecked() => _buildBookmarkedLoading(),
      BookmarkError() => _buildBookmarkedEmpty(),
      _ => _buildBookmarkedLoading(),
    };
  }

  Widget _buildBookmarkedLoading() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: SizeConstants.movieListSectionHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: SizeConstants.pagePadding,
          ),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              width: SizeConstants.movieCardWidth,
              margin: const EdgeInsets.only(right: SizeConstants.spaceS),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConstants.radiusS),
                color: Colors.grey[800],
              ),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookmarkedMovies(List<MovieModel> bookmarks) {
    if (bookmarks.isEmpty) {
      return _buildBookmarkedEmpty();
    }

    final displayBookmarks = bookmarks.take(5).toList();

    return SliverToBoxAdapter(
      child: SizedBox(
        height: SizeConstants.bookMarkSectionHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: SizeConstants.pagePadding,
          ),
          itemCount: displayBookmarks.length,
          itemBuilder: (context, index) {
            final movie = displayBookmarks[index];
            return GestureDetector(
              onTap: () => context.push('/movie/${movie.id}'),
              child: Container(
                width: SizeConstants.bookmarkCardWidth,
                margin: const EdgeInsets.only(right: SizeConstants.spaceS),
                child: Stack(
                  children: [
                    if (movie.posterPath != null)
                      CachedMoviePoster(
                        imageUrl: movie.posterUrlLarge,
                        width: SizeConstants.bookmarkCardWidth,
                        height: SizeConstants.bookMarkSectionHeight,
                        fit: BoxFit.fitHeight,
                      )
                    else
                      Container(
                        width: SizeConstants.movieCardWidth,
                        height: SizeConstants.movieListSectionHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            SizeConstants.radiusS,
                          ),
                          color: Colors.grey[800],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.movie,
                            color: AppColors.textSecondary,
                            size: SizeConstants.iconSizeXL,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookmarkedEmpty() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: SizeConstants.movieListSectionHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: SizeConstants.pagePadding,
          ),
          itemCount: 1,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => context.push('/saved'),
              child: Container(
                width: SizeConstants.bookmarkEmptyCardWidth,
                margin: const EdgeInsets.only(right: SizeConstants.spaceS),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConstants.radiusS),
                  color: Colors.grey[800],
                  border: Border.all(color: Colors.grey[600]!),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        size: SizeConstants.iconSizeXL,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: SizeConstants.spaceS),
                      Text(
                        AppTexts.noBookmarksYet,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
