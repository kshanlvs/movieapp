import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildSimplePlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[900],
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[800],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.grey, size: 32),
          SizedBox(height: 8),
          Text(
            'Failed to load',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// Variant for poster images with rounded corners
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
      borderRadius: BorderRadius.circular(8),
    );
  }
}

// Variant for backdrop/hero images
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