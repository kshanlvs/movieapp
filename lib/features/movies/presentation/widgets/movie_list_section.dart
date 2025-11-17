import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';
import 'package:movieapp/features/movies/presentation/widgets/movie_card.dart';

class MovieListSection extends StatelessWidget {
  final List<MovieModel> movies;
  final bool isLoading;
  final String error;
  final VoidCallback onRetry;
  final VoidCallback? onSeeAll;

  const MovieListSection({
    super.key,
    required this.movies,
    required this.isLoading,
    required this.error,
    required this.onRetry,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return _buildMovieList();
  }

  Widget _buildMovieList() {
    if (error.isNotEmpty) {
      return _buildErrorState();
    }

    if (isLoading && movies.isEmpty) {
      return _buildLoadingState();
    }

    if (movies.isEmpty) {
      return _buildEmptyState();
    }

    return _buildMovieGrid();
  }

  Widget _buildErrorState() {
    return SliverToBoxAdapter(
      child: Container(
        height: AppSizes.s200,
        padding: EdgeInsets.all(AppSizes.s16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                AppTexts.errorLoadingMovies,
                style: TextStyle(color: AppColors.textPrimary),
              ),
              SizedBox(height: AppSizes.s8),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textPrimary,
                ),
                child: const Text(AppTexts.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: AppSizes.s200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: AppSizes.s16),
          itemCount: 10,
          itemBuilder: (context, index) {
            return const MovieCardShimmer();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: AppSizes.s200,
        child: const Center(
          child: Text(
            AppTexts.noMoviesAvailable,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieGrid() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: AppSizes.s220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: AppSizes.s16),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return MovieCard(
              movie: movie,
              onTap: () {
                context.push('/movie/${movie.id}');
              },
            );
          },
        ),
      ),
    );
  }
}
