import 'package:flutter/material.dart';
import 'package:mymoviedb/data/database.dart';
import 'movie_list_tile.dart';

/// A widget to show a list of movies
class MovieList extends StatelessWidget {
  final List<Movie> moviesList;
  final Function(int) onEditMovie;

  const MovieList({
    super.key,
    required this.moviesList,
    required this.onEditMovie,
  });

  @override
  Widget build(BuildContext context) {
    if (moviesList.isEmpty) {
      return const Center(
        child: Text('No movies found.  Click + to add one'),
      );
    } else {
      return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 5);
        },
        itemBuilder: (context, index) {
          Movie movie = moviesList[index];
          return MovieListTile(
            key: ValueKey(movie.id),
            movie: movie,
            onTap: () {
              onEditMovie(movie.id);
            },
          );
        },
        itemCount: moviesList.length,
      );
    }
  }
}
