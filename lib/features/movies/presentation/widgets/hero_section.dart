import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/app_radius.dart';
import 'package:movieapp/core/constants/font_size_constants.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
import 'package:movieapp/features/movies/presentation/widgets/cached_movie_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';

class HeroSection extends StatelessWidget {
  final MovieModel? movie;
  final bool isLoading;
  final String? error;

  const HeroSection({
    super.key,
    this.movie,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const HeroSectionShimmer();
    }

    if (error != null && error!.isNotEmpty) {
      return _buildErrorPlaceholder();
    }

    if (movie == null) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverToBoxAdapter(
      child: Stack(
        children: [
          SizedBox(
            height: AppSizes.s500,
            width: double.infinity,
            child: CachedMovieBackdrop(imageUrl: movie?.posterUrl ?? ''),
          ),

          Container(
            height: AppSizes.s500,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background.withOpacity(0.7),
                  AppColors.background,
                ],
              ),
            ),
          ),

          Container(
            height: AppSizes.s500,
            padding: EdgeInsets.all(AppSizes.s16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildActionButton(
                      AppTexts.play,
                      Icons.play_arrow,
                      AppColors.textPrimary,
                      AppColors.background,
                    ),
                    SizedBox(width: AppSizes.s16),
                    _buildActionButton(
                      AppTexts.myList,
                      Icons.add,
                      AppColors.textSecondary,
                      AppColors.textPrimary,
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.s16),
                Text(
                  movie!.overview ?? '',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: FontSizes.bodyMedium,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return SliverToBoxAdapter(
      child: Container(
        height: AppSizes.s320,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.surfaceVariant.withOpacity(0.8),
              AppColors.background,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.s20),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: AppColors.textSecondary,
                size: AppSizes.s40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color backgroundColor,
    Color textColor,
  ) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r4),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.s16,
          vertical: AppSizes.s8,
        ),
      ),
      icon: Icon(icon, size: AppSizes.s20),
      label: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class HeroSectionShimmer extends StatelessWidget {
  const HeroSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            height: AppSizes.s500,
            width: double.infinity,
            color: AppColors.surfaceVariant,
          ),

          Container(
            height: AppSizes.s500,
            padding: EdgeInsets.all(AppSizes.s16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.surfaceVariant,
                  highlightColor: Colors.grey[700]!,
                  child: Container(
                    height: AppSizes.s40,
                    width: AppSizes.wShimmerMedium,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                    ),
                  ),
                ),
                SizedBox(height: AppSizes.s16),
                Row(
                  children: [
                    _buildShimmerButton(),
                    SizedBox(width: AppSizes.s16),
                    _buildShimmerButton(),
                  ],
                ),
                SizedBox(height: AppSizes.s16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.surfaceVariant,
                      highlightColor: Colors.grey[700]!,
                      child: Container(
                        height: AppSizes.hShimmerText,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppRadius.r4),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.s8),
                    Shimmer.fromColors(
                      baseColor: AppColors.surfaceVariant,
                      highlightColor: Colors.grey[700]!,
                      child: Container(
                        height: AppSizes.hShimmerText,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppRadius.r4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerButton() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: Colors.grey[700]!,
      child: Container(
        width: AppSizes.wShimmerSmall,
        height: AppSizes.hButtonM,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.r4),
        ),
      ),
    );
  }
}
