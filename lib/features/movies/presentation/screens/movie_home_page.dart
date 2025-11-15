import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/movies/presentation/widgets/hero_section.dart';
import 'package:movieapp/features/movies/presentation/widgets/movie_list_section.dart';
import 'package:movieapp/features/now_playing_movies/presentation/bloc/now_playing_movie_bloc.dart';
import 'package:movieapp/features/now_playing_movies/presentation/bloc/now_playing_movie_event.dart';
import 'package:movieapp/features/now_playing_movies/presentation/bloc/now_playing_state.dart';
import 'package:movieapp/features/trending_movies/presentation/bloc/trending_movie_bloc.dart';
import 'package:movieapp/features/trending_movies/presentation/bloc/trending_movie_event.dart';
import 'package:movieapp/features/trending_movies/presentation/bloc/trending_movie_state.dart';

class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key});

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<TrendingMoviesBloc>().add(FetchTrendingMovies());
    context.read<NowPlayingMoviesBloc>().add(FetchNowPlayingMovies());

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _appBarOpacity = (_scrollController.offset / 100).clamp(0.0, 1.0);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        backgroundColor: Colors.black,
        color: Colors.red,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: _buildSlivers(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black.withOpacity(_appBarOpacity),
      elevation: 0,
      title: Row(
        children: [
          Text(
            'MovieApp',
            style: TextStyle(
              color: Colors.red,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    context.read<TrendingMoviesBloc>().add(FetchTrendingMovies());
    context.read<NowPlayingMoviesBloc>().add(FetchNowPlayingMovies());
  }

  List<Widget> _buildSlivers() {
    return [
      BlocBuilder<TrendingMoviesBloc, TrendingMoviesState>(
        builder: (context, state) {
          return HeroSection(
            movie: state.movies.isNotEmpty ? state.movies.first : null,
            isLoading: state.isLoading && state.movies.isEmpty,
          );
        },
      ),

      _buildSectionHeader('Continue Watching'),
      _buildContinueWatchingSection(),
      _buildSectionHeader('Trending Now'),
      BlocBuilder<TrendingMoviesBloc, TrendingMoviesState>(
        builder: (context, state) {
          return MovieListSection(
            movies: state.movies,
            isLoading: state.isLoading,
            error: state.error,
            onRetry: () =>
                context.read<TrendingMoviesBloc>().add(FetchTrendingMovies()),
          );
        },
      ),
      _buildSectionHeader('Now Playing'),
      BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
        builder: (context, state) {
          return MovieListSection(
            movies: state.movies,
            isLoading: state.isLoading,
            error: state.error,
            onRetry: () => context.read<NowPlayingMoviesBloc>().add(
              FetchNowPlayingMovies(),
            ),
          );
        },
      ),

      _buildSectionHeader('Popular on MovieApp'),
      _buildPopularSection(),
      const SliverToBoxAdapter(child: SizedBox(height: 40)),
    ];
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (onSeeAll != null)
              TextButton(
                onPressed: onSeeAll,
                child: const Text(
                  'See All',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueWatchingSection() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              width: 280,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
              ),
              child: const Center(
                child: Text(
                  'Continue Watching\n(Feature Coming Soon)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPopularSection() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              width: 120,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
              ),
              child: const Center(
                child: Text(
                  'Popular\n(Coming Soon)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
