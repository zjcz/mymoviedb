import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mymoviedb/app/widgets/movie_list_tile.dart';
import 'package:mymoviedb/data/database.dart';
import 'package:mymoviedb/data/tables.dart';

void main() {
  group('MovieListTile', () {
    Movie createMovie(String title, String description) {
      return Movie(
          id: 1,
          title: title,
          description: description,
          director: '',
          releaseYear: 2025,
          genre: '',
          format: MovieFormat.dvd,
          ageRating: AgeRating.universal,
          addedDate: DateTime(2025, 1, 2));
    }

    testWidgets('displays movie title and description',
        (WidgetTester tester) async {
      final movie =
          createMovie('Test Movie', 'This is a test movie description.');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListTile(
              movie: movie,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Movie'), findsOneWidget);
      expect(find.text('This is a test movie description.'), findsOneWidget);
    });

    testWidgets('displays shortened description if too long',
        (WidgetTester tester) async {
      final longDescription = 'A' * 150;
      final movie = createMovie('Test Movie', longDescription);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: MovieListTile(
                movie: movie,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Movie'), findsOneWidget);
      expect(
          find.text('${longDescription.substring(0, 100)}...'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;
      final movie =
          createMovie('Test Movie', 'This is a test movie description.');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListTile(
              movie: movie,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(MovieListTile));
      expect(tapped, isTrue);
    });
  });
}
