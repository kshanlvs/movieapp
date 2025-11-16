// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Saved Movies',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        elevation: SizeConstants.appBarElevation,
        iconTheme: const IconThemeData(color: Colors.white),
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
    return const Center(child: CircularProgressIndicator(color: Colors.red));
  }

  Widget _buildBookmarks(List<MovieModel> bookmarks) {
    if (bookmarks.isEmpty) {
      return _buildEmptyState();
    }
    return Padding(
      padding: const EdgeInsets.all(SizeConstants.pagePadding),
      child: ListView.separated(
        itemCount: bookmarks.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: SizeConstants.spaceM),
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
            size: SizeConstants.iconSizeXXXL,
            color: Colors.grey[600],
          ),
          const SizedBox(height: SizeConstants.spaceL),
          const Text(
            'No Saved Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SizeConstants.spaceS),
          const Text(
            'Movies you save will appear here',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: SizeConstants.spaceXXL),
          ElevatedButton(
            onPressed: () {
              // Navigate to home to browse movies
              // context.go('/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: SizeConstants.paddingXXL,
                vertical: SizeConstants.paddingM,
              ),
            ),
            child: const Text('Browse Movies'),
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
            size: SizeConstants.iconSizeXXL,
            color: Colors.red[300],
          ),
          const SizedBox(height: SizeConstants.spaceL),
          const Text(
            'Failed to load saved movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SizeConstants.spaceS),
          Text(
            message,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SizeConstants.spaceL),
          ElevatedButton(
            onPressed: () {
              context.read<BookmarkBloc>().add(LoadBookmarks());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
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
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(SizeConstants.radiusM),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: SizeConstants.borderWidthXS,
          ),
        ),
        child: Row(
          children: [
            // Movie Poster
            Container(
              width: 100,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(SizeConstants.radiusM),
                  bottomLeft: Radius.circular(SizeConstants.radiusM),
                ),
                color: Colors.grey[800],
              ),
              child: movie.posterPath != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(SizeConstants.radiusM),
                        bottomLeft: Radius.circular(SizeConstants.radiusM),
                      ),
                      child: CachedMovieImage(
                        imageUrl: movie.posterUrlMedium,
                        width: 100,
                        height: double.infinity,
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.movie,
                        color: Colors.white70,
                        size: SizeConstants.iconSizeXL,
                      ),
                    ),
            ),

            // Movie Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(SizeConstants.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Expanded(
                      child: Text(
                        movie.title ?? 'Unknown Title',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: SizeConstants.spaceS),

                    // Rating and Year
                    Row(
                      children: [
                        // Rating
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: SizeConstants.iconSizeS,
                            ),
                            const SizedBox(width: SizeConstants.spaceXS),
                            Text(
                              movie.voteAverage?.toStringAsFixed(1) ?? 'N/A',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: SizeConstants.spaceL),

                        // Release Year
                        if (movie.releaseDate != null)
                          Text(
                            movie.releaseDate!.split('-')[0],
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: SizeConstants.spaceS),

                    // Overview (truncated)
                    if (movie.overview != null && movie.overview!.isNotEmpty)
                      Text(
                        movie.overview!,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),

            // Remove Button
            Padding(
              padding: const EdgeInsets.all(SizeConstants.paddingL),
              child: IconButton(
                onPressed: () {
                  _showRemoveDialog(context, movie);
                },
                icon: const Icon(
                  Icons.bookmark_remove,
                  color: Colors.red,
                  size: SizeConstants.iconSizeL,
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
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Remove from Saved?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Remove "${movie.title}" from your saved movies?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<BookmarkBloc>().add(ToggleBookmark(movie: movie));
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.white,
                  content: Text('Removed "${movie.title}" from saved'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
