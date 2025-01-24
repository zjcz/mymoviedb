import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mymoviedb/data/database.dart';
import 'package:mymoviedb/data/tables.dart';

MovieDatabase _createTestDb() {
  return MovieDatabase.forTesting(NativeDatabase.memory());
}

void main() {
  late MovieDatabase db;

  setUp(() {
    db = _createTestDb();
  });

  tearDown(() async {
    await db.close();
  });

  group('Movie operations', () {
    test('can insert and retrieve a movie', () async {
      final movie = MoviesCompanion.insert(
        title: 'Test Movie',
        director: 'Test Director',
        releaseYear: 2024,
        genre: 'Test Genre',
        ageRating: Value(AgeRating.teen),
      );

      final id = await db.insertMovie(movie);
      expect(id, 1);

      final retrieved = await db.getMovie(id);
      expect(retrieved.title, 'Test Movie');
      expect(retrieved.director, 'Test Director');
      expect(retrieved.releaseYear, 2024);
      expect(retrieved.genre, 'Test Genre');
      expect(retrieved.format, MovieFormat.dvd); // Default format
      expect(retrieved.ageRating, AgeRating.teen);
    });

    test('movie has default age rating when not specified', () async {
      final movie = MoviesCompanion.insert(
        title: 'Test Movie',
        director: 'Test Director',
        releaseYear: 2024,
        genre: 'Test Genre',
      );

      final id = await db.insertMovie(movie);
      final retrieved = await db.getMovie(id);
      expect(retrieved.ageRating, AgeRating.parentalGuidance); // Default age rating
    });

    test('can update a movie', () async {
      final movie = MoviesCompanion.insert(
        title: 'Original Title',
        director: 'Original Director',
        releaseYear: 2024,
        genre: 'Test Genre',
      );

      final id = await db.insertMovie(movie);
      var retrieved = await db.getMovie(id);
      
      final updated = retrieved.copyWith(
        title: 'Updated Title',
        director: 'Updated Director',
      );
      
      final success = await db.updateMovie(updated);
      expect(success, true);

      retrieved = await db.getMovie(id);
      expect(retrieved.title, 'Updated Title');
      expect(retrieved.director, 'Updated Director');
    });

    test('can delete a movie', () async {
      final movie = MoviesCompanion.insert(
        title: 'To Delete',
        director: 'Test Director',
        releaseYear: 2024,
        genre: 'Test Genre',
      );

      final id = await db.insertMovie(movie);
      await db.deleteMovie(id);

      expect(
        () => db.getMovie(id),
        throwsStateError,
      );
    });

    test('can get all movies', () async {
      final movies = [
        MoviesCompanion.insert(
          title: 'Movie 1',
          director: 'Director 1',
          releaseYear: 2024,
          genre: 'Genre 1',
        ),
        MoviesCompanion.insert(
          title: 'Movie 2',
          director: 'Director 2',
          releaseYear: 2024,
          genre: 'Genre 2',
        ),
      ];

      for (final movie in movies) {
        await db.insertMovie(movie);
      }

      final allMovies = await db.getAllMovies();
      expect(allMovies.length, 2);
      expect(allMovies[0].title, 'Movie 1');
      expect(allMovies[1].title, 'Movie 2');
    });
  });

  group('Location operations', () {
    test('can insert and retrieve a location', () async {
      final location = LocationsCompanion.insert(
        name: 'Test Location',
        description: const Value('Test Description'),
      );

      final id = await db.insertLocation(location);
      expect(id, 1);

      final retrieved = await db.getLocation(id);
      expect(retrieved.name, 'Test Location');
      expect(retrieved.description, 'Test Description');
    });

    test('can update a location', () async {
      final location = LocationsCompanion.insert(
        name: 'Original Name',
        description: const Value('Original Description'),
      );

      final id = await db.insertLocation(location);
      var retrieved = await db.getLocation(id);
      
      final updated = retrieved.copyWith(
        name: 'Updated Name',
        description: Value('Updated Description'),
      );
      
      final success = await db.updateLocation(updated);
      expect(success, true);

      retrieved = await db.getLocation(id);
      expect(retrieved.name, 'Updated Name');
      expect(retrieved.description, 'Updated Description');
    });

    test('can delete a location', () async {
      final location = LocationsCompanion.insert(
        name: 'To Delete',
        description: const Value('Test Description'),
      );

      final id = await db.insertLocation(location);
      await db.deleteLocation(id);

      expect(
        () => db.getLocation(id),
        throwsStateError,
      );
    });

    test('can get movies by location', () async {
      final location = LocationsCompanion.insert(
        name: 'Test Location',
        description: const Value('Test Description'),
      );
      final locationId = await db.insertLocation(location);

      final movies = [
        MoviesCompanion.insert(
          title: 'Movie 1',
          director: 'Director 1',
          releaseYear: 2024,
          genre: 'Genre 1',
          locationId: Value(locationId),
        ),
        MoviesCompanion.insert(
          title: 'Movie 2',
          director: 'Director 2',
          releaseYear: 2024,
          genre: 'Genre 2',
          locationId: Value(locationId),
        ),
      ];

      for (final movie in movies) {
        await db.insertMovie(movie);
      }

      final moviesInLocation = await db.getMoviesByLocation(locationId);
      expect(moviesInLocation.length, 2);
      expect(moviesInLocation[0].title, 'Movie 1');
      expect(moviesInLocation[1].title, 'Movie 2');
      expect(moviesInLocation[0].locationId, locationId);
      expect(moviesInLocation[1].locationId, locationId);
    });

    test('movies are correctly filtered by different locations', () async {
      // Create two different locations
      final location1 = LocationsCompanion.insert(
        name: 'Living Room Shelf',
        description: const Value('Main shelf in living room'),
      );
      final location2 = LocationsCompanion.insert(
        name: 'Basement Storage',
        description: const Value('Storage unit in basement'),
      );

      final location1Id = await db.insertLocation(location1);
      final location2Id = await db.insertLocation(location2);

      // Add a movie to each location
      final movie1 = MoviesCompanion.insert(
        title: 'The Matrix',
        director: 'Wachowski Sisters',
        releaseYear: 1999,
        genre: 'Sci-Fi',
        locationId: Value(location1Id),
      );

      final movie2 = MoviesCompanion.insert(
        title: 'Inception',
        director: 'Christopher Nolan',
        releaseYear: 2010,
        genre: 'Sci-Fi',
        locationId: Value(location2Id),
      );

      await db.insertMovie(movie1);
      await db.insertMovie(movie2);

      // Test movies in location 1
      final moviesInLocation1 = await db.getMoviesByLocation(location1Id);
      expect(moviesInLocation1.length, 1);
      expect(moviesInLocation1[0].title, 'The Matrix');
      expect(moviesInLocation1[0].locationId, location1Id);

      // Test movies in location 2
      final moviesInLocation2 = await db.getMoviesByLocation(location2Id);
      expect(moviesInLocation2.length, 1);
      expect(moviesInLocation2[0].title, 'Inception');
      expect(moviesInLocation2[0].locationId, location2Id);

      // Verify total number of movies in database
      final allMovies = await db.getAllMovies();
      expect(allMovies.length, 2);
    });
  });

  group('Search operations', () {
    test('can search movies by exact title', () async {
      final movies = [
        MoviesCompanion.insert(
          title: 'The Matrix',
          director: 'Wachowski Sisters',
          releaseYear: 1999,
          genre: 'Sci-Fi',
        ),
        MoviesCompanion.insert(
          title: 'The Matrix Reloaded',
          director: 'Wachowski Sisters',
          releaseYear: 2003,
          genre: 'Sci-Fi',
        ),
        MoviesCompanion.insert(
          title: 'Inception',
          director: 'Christopher Nolan',
          releaseYear: 2010,
          genre: 'Sci-Fi',
        ),
      ];

      for (final movie in movies) {
        await db.insertMovie(movie);
      }

      final results = await db.searchMoviesByTitle('Inception');
      expect(results.length, 1);
      expect(results[0].title, 'Inception');
    });

    test('can search movies case insensitively', () async {
      final movie = MoviesCompanion.insert(
        title: 'The Matrix',
        director: 'Wachowski Sisters',
        releaseYear: 1999,
        genre: 'Sci-Fi',
      );
      await db.insertMovie(movie);

      final resultsLower = await db.searchMoviesByTitle('matrix');
      expect(resultsLower.length, 1);
      expect(resultsLower[0].title, 'The Matrix');

      final resultsUpper = await db.searchMoviesByTitle('MATRIX');
      expect(resultsUpper.length, 1);
      expect(resultsUpper[0].title, 'The Matrix');
    });

    test('can search movies by partial title', () async {
      final movies = [
        MoviesCompanion.insert(
          title: 'The Matrix',
          director: 'Wachowski Sisters',
          releaseYear: 1999,
          genre: 'Sci-Fi',
        ),
        MoviesCompanion.insert(
          title: 'The Matrix Reloaded',
          director: 'Wachowski Sisters',
          releaseYear: 2003,
          genre: 'Sci-Fi',
        ),
        MoviesCompanion.insert(
          title: 'Matrix Revolutions',
          director: 'Wachowski Sisters',
          releaseYear: 2003,
          genre: 'Sci-Fi',
        ),
      ];

      for (final movie in movies) {
        await db.insertMovie(movie);
      }

      final results = await db.searchMoviesByTitle('Matrix');
      expect(results.length, 3);
      expect(results.any((m) => m.title == 'The Matrix'), true);
      expect(results.any((m) => m.title == 'The Matrix Reloaded'), true);
      expect(results.any((m) => m.title == 'Matrix Revolutions'), true);
    });

    test('search returns empty list when no matches found', () async {
      final movie = MoviesCompanion.insert(
        title: 'The Matrix',
        director: 'Wachowski Sisters',
        releaseYear: 1999,
        genre: 'Sci-Fi',
      );
      await db.insertMovie(movie);

      final results = await db.searchMoviesByTitle('Star Wars');
      expect(results.isEmpty, true);
    });

    test('can search movies by director', () async {
      final movies = [
        MoviesCompanion.insert(
          title: 'Inception',
          director: 'Christopher Nolan',
          releaseYear: 2010,
          genre: 'Sci-Fi',
        ),
        MoviesCompanion.insert(
          title: 'The Dark Knight',
          director: 'Christopher Nolan',
          releaseYear: 2008,
          genre: 'Action',
        ),
        MoviesCompanion.insert(
          title: 'The Matrix',
          director: 'Wachowski Sisters',
          releaseYear: 1999,
          genre: 'Sci-Fi',
        ),
      ];

      for (final movie in movies) {
        await db.insertMovie(movie);
      }

      final results = await db.searchMoviesByDirector('Nolan');
      expect(results.length, 2);
      expect(results.any((m) => m.title == 'Inception'), true);
      expect(results.any((m) => m.title == 'The Dark Knight'), true);
    });

    test('can search movies by genre', () async {
      final movies = [
        MoviesCompanion.insert(
          title: 'Inception',
          director: 'Christopher Nolan',
          releaseYear: 2010,
          genre: 'Sci-Fi',
        ),
        MoviesCompanion.insert(
          title: 'The Matrix',
          director: 'Wachowski Sisters',
          releaseYear: 1999,
          genre: 'Sci-Fi',
        ),
        MoviesCompanion.insert(
          title: 'The Dark Knight',
          director: 'Christopher Nolan',
          releaseYear: 2008,
          genre: 'Action',
        ),
      ];

      for (final movie in movies) {
        await db.insertMovie(movie);
      }

      final results = await db.searchMoviesByGenre('Sci-Fi');
      expect(results.length, 2);
      expect(results.any((m) => m.title == 'Inception'), true);
      expect(results.any((m) => m.title == 'The Matrix'), true);
    });

    test('can filter movies by age rating', () async {
      final movies = [
        MoviesCompanion.insert(
          title: 'Toy Story',
          director: 'John Lasseter',
          releaseYear: 1995,
          genre: 'Animation',
          ageRating: Value(AgeRating.universal),
        ),
        MoviesCompanion.insert(
          title: 'The Matrix',
          director: 'Wachowski Sisters',
          releaseYear: 1999,
          genre: 'Sci-Fi',
          ageRating: Value(AgeRating.mature),
        ),
      ];

      for (final movie in movies) {
        await db.insertMovie(movie);
      }

      final results = await db.getMoviesByAgeRating(AgeRating.universal);
      expect(results.length, 1);
      expect(results[0].title, 'Toy Story');
    });

    test('can filter movies by format', () async {
      final movies = [
        MoviesCompanion.insert(
          title: 'Inception',
          director: 'Christopher Nolan',
          releaseYear: 2010,
          genre: 'Sci-Fi',
          format: Value(MovieFormat.bluray),
        ),
        MoviesCompanion.insert(
          title: 'The Matrix',
          director: 'Wachowski Sisters',
          releaseYear: 1999,
          genre: 'Sci-Fi',
          format: Value(MovieFormat.dvd),
        ),
      ];

      for (final movie in movies) {
        await db.insertMovie(movie);
      }

      final results = await db.getMoviesByFormat(MovieFormat.bluray);
      expect(results.length, 1);
      expect(results[0].title, 'Inception');
    });

    test('can perform advanced search with multiple criteria', () async {
      final movies = [
        MoviesCompanion.insert(
          title: 'Inception',
          director: 'Christopher Nolan',
          releaseYear: 2010,
          genre: 'Sci-Fi',
          format: Value(MovieFormat.bluray),
          ageRating: Value(AgeRating.teen),
        ),
        MoviesCompanion.insert(
          title: 'The Dark Knight',
          director: 'Christopher Nolan',
          releaseYear: 2008,
          genre: 'Action',
          format: Value(MovieFormat.dvd),
          ageRating: Value(AgeRating.teen),
        ),
        MoviesCompanion.insert(
          title: 'The Matrix',
          director: 'Wachowski Sisters',
          releaseYear: 1999,
          genre: 'Sci-Fi',
          format: Value(MovieFormat.dvd),
          ageRating: Value(AgeRating.mature),
        ),
      ];

      for (final movie in movies) {
        await db.insertMovie(movie);
      }

      // Search for Nolan's Sci-Fi movies from 2010 onwards
      final criteria = MovieSearchCriteria(
        directorQuery: 'Nolan',
        genreQuery: 'Sci-Fi',
        fromYear: 2010,
      );

      final results = await db.searchMovies(criteria);
      expect(results.length, 1);
      expect(results[0].title, 'Inception');

      // Search for teen-rated movies in DVD format
      final criteria2 = MovieSearchCriteria(
        ageRating: AgeRating.teen,
        format: MovieFormat.dvd,
      );

      final results2 = await db.searchMovies(criteria2);
      expect(results2.length, 1);
      expect(results2[0].title, 'The Dark Knight');

      // Search for all Sci-Fi movies between 1995 and 2010
      final criteria3 = MovieSearchCriteria(
        genreQuery: 'Sci-Fi',
        fromYear: 1995,
        toYear: 2010,
      );

      final results3 = await db.searchMovies(criteria3);
      expect(results3.length, 2);
      expect(results3.any((m) => m.title == 'Inception'), true);
      expect(results3.any((m) => m.title == 'The Matrix'), true);
    });
  });
}
