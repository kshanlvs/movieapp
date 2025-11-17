import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/core/constants/app_radius.dart';
import 'package:movieapp/core/constants/font_size_constants.dart';
import 'package:movieapp/core/constants/size_constants.dart';
import 'package:movieapp/core/constants/string_constants.dart';
import 'package:movieapp/core/network/movie_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

class CachedMovieImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry borderRadius;
  final bool showShimmer;

  const CachedMovieImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.showShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheManager: MovieCacheManager(),
        placeholder: (context, url) => showShimmer
            ? _buildShimmerPlaceholder()
            : _buildSimplePlaceholder(),
        errorWidget: (context, url, error) => _buildErrorWidget(),
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        color: AppColors.placeholderBackground,
      ),
    );
  }

  Widget _buildSimplePlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.placeholderBackground,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 1,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceVariant,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.textSecondary,
            size: AppSizes.s24,
          ),
          SizedBox(height: AppSizes.s8),
          const Text(
            AppTexts.failedToLoad,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: FontSizes.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class CachedMoviePoster extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const CachedMoviePoster({
    super.key,
    required this.imageUrl,
    this.width = 120,
    this.height = 180,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedMovieImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: BorderRadius.circular(AppRadius.r8),
    );
  }
}

class CachedMovieBackdrop extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CachedMovieBackdrop({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedMovieImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      showShimmer: false,
    );
  }
}
