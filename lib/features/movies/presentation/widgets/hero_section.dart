// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
import 'package:movieapp/features/movies/presentation/widgets/cached_movie_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:movieapp/features/movies/data/model/movie_model.dart';

class HeroSection extends StatelessWidget {
  final MovieModel? movie;
  final bool isLoading;

  const HeroSection({super.key, this.movie, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const HeroSectionShimmer();
    }

    if (movie == null) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverToBoxAdapter(
      child: Stack(
        children: [
          SizedBox(
            height: 500,
            width: double.infinity,
            child: CachedMovieBackdrop(imageUrl: movie?.posterUrl ?? ''),
          ),

          Container(
            height: 500,
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
            height: 500,
            padding: const EdgeInsets.all(SizeConstants.pagePadding),
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
                    const SizedBox(width: SizeConstants.spaceL),
                    _buildActionButton(
                      AppTexts.myList,
                      Icons.add,
                      AppColors.textSecondary,
                      AppColors.textPrimary,
                    ),
                  ],
                ),
                const SizedBox(height: SizeConstants.spaceL),
                Text(
                  movie!.overview ?? '',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
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
          borderRadius: BorderRadius.circular(SizeConstants.radiusXS),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: SizeConstants.paddingL,
          vertical: SizeConstants.paddingS,
        ),
      ),
      icon: Icon(icon, size: SizeConstants.iconSizeM),
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
            height: 500,
            width: double.infinity,
            color: Colors.grey[900],
          ),

          Container(
            height: 500,
            padding: const EdgeInsets.all(SizeConstants.pagePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[700]!,
                  child: Container(
                    height: 40,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(
                        SizeConstants.radiusS,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: SizeConstants.spaceL),
                Row(
                  children: [
                    _buildShimmerButton(),
                    const SizedBox(width: SizeConstants.spaceL),
                    _buildShimmerButton(),
                  ],
                ),
                const SizedBox(height: SizeConstants.spaceL),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(
                            SizeConstants.radiusXS,
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
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(
                            SizeConstants.radiusXS,
                          ),
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
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        width: 100,
        height: SizeConstants.buttonHeightM,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(SizeConstants.radiusXS),
        ),
      ),
    );
  }
}
