import 'package:movieapp/core/constants/api_constants.dart';

enum ImageSize {
  w92('w92'),
  w154('w154'),
  w185('w185'),
  w342('w342'),
  w500('w500'),
  w780('w780'),
  w1280('w1280'),
  w300('w300'),
  original('original');

  final String value;
  const ImageSize(this.value);
}

abstract class ImageUrlGenerator {
  String generatePosterUrl(String? posterPath, ImageSize size);
  String generateBackdropUrl(String? backdropPath, ImageSize size);
}

class TmdbImageUrlGenerator implements ImageUrlGenerator {
  const TmdbImageUrlGenerator();

  @override
  String generatePosterUrl(String? posterPath, ImageSize size) {
    return _generateImageUrl(posterPath, size);
  }

  @override
  String generateBackdropUrl(String? backdropPath, ImageSize size) {
    return _generateImageUrl(backdropPath, size);
  }

  String _generateImageUrl(String? imagePath, ImageSize size) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }

    final cleanPath = imagePath.startsWith('/')
        ? imagePath.substring(1)
        : imagePath;

    return '${ApiConstants.imageBaseUrl}/${size.value}/$cleanPath';
  }
}

abstract class PosterUrlGenerator {
  String generatePosterUrl(String? posterPath, ImageSize size);
}

abstract class BackdropUrlGenerator {
  String generateBackdropUrl(String? backdropPath, ImageSize size);
}

class HighQualityImageGenerator implements ImageUrlGenerator {
  @override
  String generatePosterUrl(String? posterPath, ImageSize size) {
    return const TmdbImageUrlGenerator().generatePosterUrl(
      posterPath,
      ImageSize.original,
    );
  }

  @override
  String generateBackdropUrl(String? backdropPath, ImageSize size) {
    return const TmdbImageUrlGenerator().generateBackdropUrl(
      backdropPath,
      ImageSize.original,
    );
  }
}
