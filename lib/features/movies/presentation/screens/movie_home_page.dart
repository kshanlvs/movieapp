import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/movies/presentation/bloc/movie_state.dart';
import 'package:movieapp/features/movies/presentation/widgets/custom_error_widget.dart';
import 'package:movieapp/features/movies/presentation/widgets/loading_widget.dart';
import 'package:movieapp/features/movies/presentation/widgets/movie_grid_widget.dart';

import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';

class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key});

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state.isLoading && state.movies.isEmpty) {
            return const LoadingWidget();
          }

          if (state.error.isNotEmpty && state.movies.isEmpty) {
            return CustomErrorWidget(
              errorMessage: state.error,
              onRetry: () =>
                  context.read<MovieBloc>().add(FetchTrendingMovies()),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<MovieBloc>().add(FetchTrendingMovies());
            },
            child: MovieGrid(movies: state.movies),
          );
        },
      ),
    );
  }
}
