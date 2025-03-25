import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';
import 'package:mymoviedb/data/database.dart';
import 'package:mymoviedb/providers/movie_controller.dart';
import 'package:mymoviedb/data/tables.dart';

@GenerateNiceMocks([MockSpec<MovieDatabase>()])
import 'movie_controller_test.mocks.dart';

void main() {
  late ProviderContainer container;
  late MockMovieDatabase mockDb;

  setUp(() {
    mockDb = MockMovieDatabase();
    container = ProviderContainer(
      overrides: [
        MovieDatabase.provider.overrideWithValue(mockDb),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('MovieController Tests', () {
    test('build returns empty list initially', () async {
      when(mockDb.getAllMovies()).thenAnswer((_) => Stream.value([]));

      final movies = await container.read(movieControllerProvider.future);
      expect(movies, isEmpty);
      verify(mockDb.getAllMovies()).called(1);
    });

    test('addMovie calls database insert', () async {
      final controller = container.read(movieControllerProvider.notifier);
      String title = 'Test Movie';
      String director = 'Test Director';
      String releaseYear = "2024";
      String genre = 'Test Genre';
      String description = 'Test Description';
      String coverImagePath = 'path/to/cover.jpg';
      MovieFormat format = MovieFormat.dvd;
      AgeRating ageRating = AgeRating.teen;
      int? locationId = 5;
      DateTime? addedDate = DateTime.now();

      MoviesCompanion movie = MoviesCompanion(
        title: Value(title),
        director: Value(director),
        releaseYear: Value(int.parse(releaseYear)),
        genre: Value(genre),
        description: Value(description),
        coverImagePath: Value(coverImagePath),
        format: Value(format),
        ageRating: Value(ageRating),
        locationId: Value(locationId),
        addedDate: Value(addedDate),
      );

      when(mockDb.insertMovie(movie)).thenAnswer((_) async => 1);

      final id = await controller.addMovie(
        title,
        director,
        int.parse(releaseYear),
        genre,
        description,
        coverImagePath,
        format,
        ageRating,
        locationId,
        addedDate,
      );
      expect(id, 1);
      verify(mockDb.insertMovie(movie)).called(1);
    });

    test('updateMovie calls database update', () async {
      final controller = container.read(movieControllerProvider.notifier);

      final movie = Movie(
        id: 1,
        title: 'Updated Title',
        director: 'Updated Director',
        releaseYear: 2024,
        genre: 'Test Genre',
        description: 'Test Description',
        coverImagePath: 'path/to/cover.jpg',
        format: MovieFormat.dvd,
        ageRating: AgeRating.teen,
        locationId: null,
        addedDate: DateTime.now(),
      );

      when(mockDb.updateMovie(movie)).thenAnswer((_) async => true);

      final success = await controller.updateMovie(movie);
      expect(success, true);
      verify(mockDb.updateMovie(movie)).called(1);
    });

    test('deleteMovie calls database delete', () async {
      final controller = container.read(movieControllerProvider.notifier);

      when(mockDb.deleteMovie(1)).thenAnswer((_) async => 1);

      final result = await controller.deleteMovie(1);
      expect(result, 1);
      verify(mockDb.deleteMovie(1)).called(1);
    });

    test('getMovie calls database get', () async {
      final controller = container.read(movieControllerProvider.notifier);

      final movie = Movie(
        id: 1,
        title: 'Test Movie',
        director: 'Test Director',
        releaseYear: 2024,
        genre: 'Test Genre',
        description: 'Test Description',
        coverImagePath: 'path/to/cover.jpg',
        format: MovieFormat.dvd,
        ageRating: AgeRating.teen,
        locationId: null,
        addedDate: DateTime.now(),
      );

      when(mockDb.getMovie(1)).thenAnswer((_) async => movie);

      final result = await controller.getMovie(1);
      expect(result, movie);
      verify(mockDb.getMovie(1)).called(1);
    });
  });
}
