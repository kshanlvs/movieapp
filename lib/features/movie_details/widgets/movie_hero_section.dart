import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_colors.dart';
import 'package:movieapp/features/movie_details/data/model/movie_detail_model.dart';
import 'package:movieapp/features/movies/presentation/widgets/cached_movie_image.dart';

class MovieHeroSection extends StatelessWidget {
  final MovieDetails details;

  const MovieHeroSection({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.background,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedMovieBackdrop(imageUrl: details.posterUrlLarge),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [AppColors.background.withOpacity(0.87), Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}