// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/app_radius.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
import 'package:movieapp/core/constants/text_style_constants.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:movieapp/features/bookmark/presentation/bloc/bookmark_state.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';
import 'package:movieapp/features/movies/presentation/widgets/cached_movie_image.dart';

class SavedMoviesPage extends StatelessWidget {
  const SavedMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppTexts.savedMovies, style: TextStyles.appBarTitle),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocBuilder<BookmarkBloc, BookmarkState>(
        builder: (context, state) {
          return switch (state) {
            BookmarkInitial() => _buildLoading(),
            BookmarkLoading() => _buildLoading(),
            BookmarkUpdated(:final bookmarks) => _buildBookmarks(bookmarks),
            BookmarkLoaded(:final bookmarks) => _buildBookmarks(bookmarks),
            BookmarkError(:final message) => _buildError(message, context),
            _ => _buildLoading(),
          };
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildBookmarks(List<MovieModel> bookmarks) {
    if (bookmarks.isEmpty) {
      return _buildEmptyState();
    }
    return Padding(
      padding: EdgeInsets.all(AppSizes.s16),
      child: ListView.separated(
        itemCount: bookmarks.length,
        separatorBuilder: (context, index) => SizedBox(height: AppSizes.s12),
        itemBuilder: (context, index) {
          final movie = bookmarks[index];
          return _SavedMovieListItem(
            movie: movie,
            onTap: () {
              context.push('/movie/${movie.id}');
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: AppSizes.s40,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppSizes.s16),
          const Text(
            AppTexts.noSavedMovies,
            style: TextStyles.searchErrorTitle,
          ),
          SizedBox(height: AppSizes.s8),
          const Text(
            AppTexts.moviesYouSaveWillAppearHere,
            style: TextStyles.searchInitialSubtitle,
          ),
          SizedBox(height: AppSizes.s24),
          ElevatedButton(
            onPressed: () {
              // context.go('/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.s24,
                vertical: AppSizes.s12,
              ),
            ),
            child: const Text(AppTexts.browseMovies),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSizes.s32,
            color: AppColors.primary,
          ),
          SizedBox(height: AppSizes.s16),
          const Text(
            AppTexts.failedToLoadSavedMovies,
            style: TextStyles.searchErrorTitle,
          ),
          SizedBox(height: AppSizes.s8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.s32),
            child: Text(
              message,
              style: TextStyles.searchErrorMessage,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: AppSizes.s16),
          ElevatedButton(
            onPressed: () {
              context.read<BookmarkBloc>().add(LoadBookmarks());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
            ),
            child: const Text(AppTexts.retry),
          ),
        ],
      ),
    );
  }
}

class _SavedMovieListItem extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback onTap;

  const _SavedMovieListItem({required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.hMovieListItem,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            // Movie Poster
            Container(
              width: AppSizes.hMoviePoster,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.r12),
                  bottomLeft: Radius.circular(AppRadius.r12),
                ),
                color: AppColors.surfaceVariant,
              ),
              child: movie.posterPath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.r12),
                        bottomLeft: Radius.circular(AppRadius.r12),
                      ),
                      child: CachedMovieImage(
                        imageUrl: movie.posterUrlMedium,
                        width: AppSizes.hMoviePoster,
                        height: double.infinity,
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.movie,
                        color: AppColors.textSecondary,
                        size: AppSizes.s28,
                      ),
                    ),
            ),

            // Movie Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Expanded(
                      child: Text(
                        movie.title ?? AppTexts.unknownTitle,
                        style: TextStyles.movieItemTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: AppSizes.s8),

                    // Rating and Year
                    SizedBox(
                      height: AppSizes.hMovieRating,
                      child: Row(
                        children: [
                          // Rating
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: AppSizes.s16,
                              ),
                              SizedBox(width: AppSizes.s4),
                              Text(
                                movie.voteAverage?.toStringAsFixed(1) ??
                                    AppTexts.notAvailable,
                                style: TextStyles.movieItemSubtitle,
                              ),
                            ],
                          ),

                          SizedBox(width: AppSizes.s16),

                          // Release Year
                          if (movie.releaseDate != null)
                            Text(
                              movie.releaseDate!.split('-')[0],
                              style: TextStyles.movieItemSubtitle,
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.s8),

                    // Overview (truncated)
                    if (movie.overview != null && movie.overview!.isNotEmpty)
                      Text(
                        movie.overview!,
                        style: TextStyles.movieItemOverview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),

            // Remove Button
            Padding(
              padding: EdgeInsets.all(AppSizes.s16),
              child: IconButton(
                onPressed: () {
                  _showRemoveDialog(context, movie);
                },
                icon: Icon(
                  Icons.bookmark_remove,
                  color: AppColors.primary,
                  size: AppSizes.s24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, MovieModel movie) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        title: const Text(
          AppTexts.removeFromSaved,
          style: TextStyles.movieItemTitle,
        ),
        content: Text(
          '${AppTexts.removeMoviePrompt} "${movie.title}"'
          ' ${AppTexts.fromYourSavedMovies}',
          style: TextStyles.movieItemOverview,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              AppTexts.cancel,
              style: TextStyles.movieItemSubtitle,
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<BookmarkBloc>().add(ToggleBookmark(movie: movie));
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.surface,
                  content: Text(
                    '${AppTexts.removed} "${movie.title}"'
                    '${AppTexts.fromSaved}',
                    style: TextStyles.movieItemOverview,
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              AppTexts.remove,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
