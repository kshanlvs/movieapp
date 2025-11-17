import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/app_radius.dart';
import 'package:movieapp/core/constants/font_size_constants.dart';
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
        margin: EdgeInsets.only(right: AppSizes.s8),
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
                      top: AppSizes.s4,
                      left: AppSizes.s4,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.s2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppRadius.r4),
                        ),
                        child: const Text(
                          AppTexts.top10,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: FontSizes.labelSmall,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.s8),
            Text(
              movie.title ?? AppTexts.unknownTitle,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: FontSizes.bodySmall,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (showRating) ...[
              SizedBox(height: AppSizes.s4),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: AppSizes.s12),
                  SizedBox(width: AppSizes.s4),
                  Text(
                    movie.voteAverage?.toStringAsFixed(1) ??
                        AppTexts.notAvailable,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: FontSizes.labelSmall,
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

  const MovieCardShimmer({super.key, this.width = 120, this.height = 180});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: AppSizes.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Shimmer.fromColors(
              baseColor: AppColors.surfaceVariant,
              highlightColor: Colors.grey[700]!,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSizes.s8),
          Shimmer.fromColors(
            baseColor: AppColors.surfaceVariant,
            highlightColor: Colors.grey[700]!,
            child: Container(
              height: AppSizes.hShimmerText,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.r4),
              ),
            ),
          ),
          SizedBox(height: AppSizes.s4),
          Shimmer.fromColors(
            baseColor: AppColors.surfaceVariant,
            highlightColor: Colors.grey[700]!,
            child: Container(
              height: AppSizes.hShimmerSmall,
              width: AppSizes.wShimmerXSmall,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.r4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
