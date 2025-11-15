import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/movie_details/data/model/movie_detail_model.dart';
import 'package:movieapp/features/movie_details/presentation/bloc/movie_detail_bloc.dart';
import 'package:movieapp/features/movie_details/presentation/bloc/movie_detail_event.dart';
import 'package:movieapp/features/movie_details/presentation/bloc/movie_detail_state.dart';
import 'package:movieapp/features/movies/presentation/widgets/cached_movie_image.dart';
import 'package:shimmer/shimmer.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage>
    with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  bool _isInMyList = false;

  late final AnimationController _fadeInController;
  late final Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _fadeInController,
      curve: Curves.easeOut,
    );

    context.read<MovieDetailBloc>().add(
      LoadMovieDetail(movieId: widget.movieId),
    );
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    super.dispose();
  }

  void _onLikePressed() {
    setState(() => _isLiked = !_isLiked);
  }

  void _onMyListPressed() {
    setState(() => _isInMyList = !_isInMyList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          switch (state) {
            case MovieDetailLoading():
            case MovieDetailInitial():
              return _buildLoadingSkeleton();

            case MovieDetailLoaded(:final movieDetail):
              _fadeInController.forward();
              return FadeTransition(
                opacity: _fadeInAnimation,
                child: _buildMovieDetailSection(movieDetail),
              );

            case MovieDetailError(:final message):
              return _buildErrorView(message);

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildMovieDetailSection(MovieDetails details) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 380,
          pinned: true,
          stretch: true,
          backgroundColor: Colors.black,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.fadeTitle,
            ],
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedMovieBackdrop(imageUrl: details.posterUrlLarge),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPrimaryActions(details),
                const SizedBox(height: 20),

                Text(
                  details.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      details.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Text(
                  details.overview ?? "",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 18),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: details.genres
                      .map(
                        (genre) => Chip(
                          label: Text(
                            genre.name,
                            style: const TextStyle(fontSize: 13),
                          ),
                          backgroundColor: Colors.white12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryActions(MovieDetails movie) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _actionButton(
          icon: _isInMyList ? Icons.check : Icons.add,
          label: "My List",
          active: _isInMyList,
          onTap: _onMyListPressed,
        ),
        _actionButton(
          icon: _isLiked ? Icons.favorite : Icons.favorite_border,
          label: "Like",
          active: _isLiked,
          onTap: _onLikePressed,
        ),
        _actionButton(icon: Icons.share, label: "Share", onTap: () {}),
        _actionButton(
          icon: Icons.download_for_offline_outlined,
          label: "Download",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: active ? 1.08 : 1.0,
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: active ? Colors.white : Colors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.white)),
    );
  }
  Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade700,
      child: Column(
        children: [
          Container(height: 350, color: Colors.black),
          const SizedBox(height: 30),
          Container(height: 20, width: 220, color: Colors.black),
          const SizedBox(height: 20),
          Container(height: 16, width: double.infinity, color: Colors.black),
          const SizedBox(height: 12),
          Container(height: 16, width: double.infinity, color: Colors.black),
        ],
      ),
    );
  }
}
