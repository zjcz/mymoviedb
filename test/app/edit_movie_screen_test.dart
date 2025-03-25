import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mymoviedb/app/edit_movie_screen.dart';
import 'package:mymoviedb/data/database.dart';
import 'package:mymoviedb/data/tables.dart';
import 'package:mymoviedb/route_config.dart';
import 'edit_movie_screen_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MovieDatabase>()])
void main() {
  late MockMovieDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockMovieDatabase();
  });

  testWidgets('Add movie - validates empty fields', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          MovieDatabase.provider.overrideWithValue(mockDatabase),
        ],
        child: MaterialApp.router(
          routerConfig: setupRouter(
            initialLocation: RouteDefs.editMovie,
            observers: [],
            testing: true,
          ),
        ),
      ),
    );

    // Try to save without entering any data
    await tester.tap(find.text('Save'));
    await tester.pump(Duration(seconds: 1));

    // Verify validation messages
    expect(find.text('Please enter some text'), findsNWidgets(5));
  });

  testWidgets('Edit movie - loads existing data', (tester) async {
    final testMovie = Movie(
        id: 1,
        title: 'Test Movie',
        director: 'Test Director',
        releaseYear: 2023,
        genre: 'Action',
        description: 'Test Description',
        format: MovieFormat.dvd,
        ageRating: AgeRating.universal,
        locationId: 1,
        addedDate: DateTime.now());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          MovieDatabase.provider.overrideWithValue(mockDatabase),
        ],
        child: MaterialApp.router(
          routerConfig: setupRouter(
            initialLocation: RouteDefs.editMovie,
            initialExtra: testMovie,
            observers: [],
            testing: true,
          ),
        ),
      ),
    );

    expect(find.text('Test Movie'), findsOneWidget);
    expect(find.text('Test Director'), findsOneWidget);
    expect(find.text('2023'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });

  testWidgets('Save movie - calls insert method correctly', (tester) async {
    when(mockDatabase.insertMovie(any)).thenAnswer((_) async => 1);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          MovieDatabase.provider.overrideWithValue(mockDatabase),
        ],
        child: MaterialApp.router(
          routerConfig: setupRouter(
            initialLocation: RouteDefs.editMovie,
            observers: [],
            testing: true,
          ),
        ),
      ),
    );

    // Fill in the form
    await tester.enterText(find.byKey(EditMovieScreen.titleKey), 'New Movie');
    await tester.enterText(find.byKey(EditMovieScreen.directorKey), 'Director');
    await tester.enterText(find.byKey(EditMovieScreen.releaseKey), '2023');
    await tester.enterText(find.byKey(EditMovieScreen.genreKey), 'Action');
    await tester.enterText(find.byKey(EditMovieScreen.descKey), 'Description');

    await tester.tap(find.text('Save'));
    await tester.pump(Duration(seconds: 1));

    // Verify the database was called
    verify(mockDatabase.insertMovie(any)).called(1);
  });

  testWidgets('Save movie - calls update method correctly', (tester) async {
    final testMovie = Movie(
        id: 1,
        title: 'Test Movie',
        director: 'Test Director',
        releaseYear: 2023,
        genre: 'Action',
        description: 'Test Description',
        format: MovieFormat.dvd,
        ageRating: AgeRating.universal,
        locationId: 1,
        addedDate: DateTime.now());

    final updatedMovie = testMovie.copyWith(        
        title: 'Updated Movie',
        director: 'Updated Director',
        releaseYear: 2025,
        genre: 'Comedy',
        description: Value('Updated Description'));

    when(mockDatabase.updateMovie(updatedMovie)).thenAnswer((_) async => true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          MovieDatabase.provider.overrideWithValue(mockDatabase),
        ],
        child: MaterialApp.router(
          routerConfig: setupRouter(
            initialLocation: RouteDefs.editMovie,
            initialExtra: testMovie,
            observers: [],
            testing: true,
          ),
        ),
      ),
    );

    // Fill in the form
    await tester.enterText(
        find.byKey(EditMovieScreen.titleKey), updatedMovie.title);
    await tester.enterText(
        find.byKey(EditMovieScreen.directorKey), updatedMovie.director);
    await tester.enterText(find.byKey(EditMovieScreen.releaseKey),
        updatedMovie.releaseYear.toString());
    await tester.enterText(
        find.byKey(EditMovieScreen.genreKey), updatedMovie.genre);
    await tester.enterText(
        find.byKey(EditMovieScreen.descKey), updatedMovie.description!);

    await tester.tap(find.text('Save'));
    await tester.pump(Duration(seconds: 1));

    // Verify the database was called
    verifyNever(mockDatabase.insertMovie(any));
    verify(mockDatabase.updateMovie(updatedMovie)).called(1);
  });

  testWidgets('Shows unsaved changes dialog', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          MovieDatabase.provider.overrideWithValue(mockDatabase),
        ],
        child: MaterialApp.router(
          routerConfig: setupRouter(
            initialLocation: RouteDefs.editMovie,
            observers: [],
            testing: true,
          ),
        ),
      ),
    );

    // Make a change
    await tester.enterText(find.byKey(EditMovieScreen.titleKey), 'New Movie');
    await tester.pump(Duration(seconds: 1));

    // Try to pop
    await tester.pageBack();
    await tester.pump(Duration(seconds: 1));

    // Verify dialog appears
    expect(find.widgetWithText(AlertDialog, "Are you sure?"), findsOneWidget);
    expect(find.text('Are you sure?'), findsOneWidget);
    expect(find.text('Any unsaved changes will be lost!'), findsOneWidget);
  });
}
