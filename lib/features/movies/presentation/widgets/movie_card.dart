import 'package:flutter/material.dart';
import 'package:movieapp/features/movies/presentation/widgets/cached_movie_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final double width;
  final double height;
  final bool showRating;
  final VoidCallback? onTap;

  const MovieCard({
    Key? key,
    required this.movie,
    this.width = 120,
    this.height = 180,
    this.showRating = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Movie Poster using custom cached image
                  CachedMoviePoster(
                    imageUrl: movie.posterUrl,
                    width: width,
                    height: height,
                  ),
                  
                  // Top 10 Badge for trending movies
                  if (movie.voteAverage != null && movie.voteAverage! > 8.0)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'TOP 10',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title ?? 'Unknown',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (showRating) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.yellow, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    movie.voteAverage?.toStringAsFixed(1) ?? 'N/A',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
class MovieCardShimmer extends StatelessWidget {
  final double width;
  final double height;

  const MovieCardShimmer({
    super.key,
    this.width = 120,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[700]!,
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[700]!,
            child: Container(
              height: 12,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}