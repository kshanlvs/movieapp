import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
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
    super.key,
    required this.movie,
    this.width = 120,
    this.height = 180,
    this.showRating = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: SizeConstants.spaceS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
              
                  CachedMoviePoster(
                    imageUrl: movie.posterUrl,
                    width: width,
                    height: height,
                  ),
                  
                  if (movie.voteAverage != null && movie.voteAverage! > 8.0)
                    Positioned(
                      top: SizeConstants.spaceXS,
                      left: SizeConstants.spaceXS,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SizeConstants.spaceXXS,
                          vertical: SizeConstants.spaceZero,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(SizeConstants.radiusXS),
                        ),
                        child: Text(
                          AppTexts.top10,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: SizeConstants.spaceS),
            Text(
              movie.title ?? AppTexts.unknownTitle,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (showRating) ...[
              const SizedBox(height: SizeConstants.spaceXS),
              Row(
                children: [
                  Icon(
                    Icons.star, 
                    color: Colors.yellow, 
                    size: SizeConstants.iconSizeXS
                  ),
                  const SizedBox(width: SizeConstants.spaceXS),
                  Text(
                    movie.voteAverage?.toStringAsFixed(1) ?? AppTexts.notAvailable,
                    style: TextStyle(
                      color: AppColors.textSecondary,
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
      margin: const EdgeInsets.only(right: SizeConstants.spaceS),
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
                  borderRadius: BorderRadius.circular(SizeConstants.radiusS),
                ),
              ),
            ),
          ),
          const SizedBox(height: SizeConstants.spaceS),
          Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[700]!,
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(SizeConstants.radiusXS),
              ),
            ),
          ),
          const SizedBox(height: SizeConstants.spaceXS),
          Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[700]!,
            child: Container(
              height: 12,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(SizeConstants.radiusXS),
              ),
            ),
          ),
        ],
      ),
    );
  }
}