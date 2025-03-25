import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mymoviedb/app/widgets/movie_list.dart';
import 'package:mymoviedb/data/database.dart';
import 'package:mymoviedb/app/widgets/movie_list_tile.dart';
import 'package:mymoviedb/data/tables.dart';

void main() {
  group('MovieList', () {
    Movie createMovie(int id, String title, String description) {
      return Movie(
        id: id,
        title: title,
        description: description,
        director: '',
        releaseYear: 2025,
        genre: '',
        format: MovieFormat.dvd,
        ageRating: AgeRating.universal,
        addedDate: DateTime(2025, 1, 2),
      );
    }

    testWidgets('displays message when movie list is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieList(
              moviesList: [],
              onEditMovie: (id) {},
            ),
          ),
        ),
      );

      expect(find.text('No movies found.  Click + to add one'), findsOneWidget);
    });

    testWidgets('displays a list of movies', (WidgetTester tester) async {
      final movies = [
        createMovie(1, 'Movie 1', 'Description 1'),
        createMovie(2, 'Movie 2', 'Description 2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieList(
              moviesList: movies,
              onEditMovie: (id) {},
            ),
          ),
        ),
      );

      expect(find.byType(MovieListTile), findsNWidgets(2));
      expect(find.text('Movie 1'), findsOneWidget);
      expect(find.text('Movie 2'), findsOneWidget);
    });

    testWidgets('calls onEditMovie when a movie is tapped', (WidgetTester tester) async {
      final movies = [
        createMovie(1, 'Movie 1', 'Description 1'),
      ];

      int? editedMovieId;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieList(
              moviesList: movies,
              onEditMovie: (id) {
                editedMovieId = id;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(MovieListTile));
      expect(editedMovieId, 1);
    });
  });
}