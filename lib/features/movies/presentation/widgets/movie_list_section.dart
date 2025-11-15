import 'package:flutter/material.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';
import 'movie_card.dart';

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
        height: 200,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Failed to load movies',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Retry'),
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
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
        height: 200,
        child: const Center(
          child: Text(
            'No movies available',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieGrid() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return MovieCard(movie: movie);
          },
        ),
      ),
    );
  }
}