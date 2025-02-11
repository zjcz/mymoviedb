import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tables.dart';

part 'database.g.dart';

// Search criteria class for advanced search
class MovieSearchCriteria {
  final String? titleQuery;
  final String? directorQuery;
  final String? genreQuery;
  final AgeRating? ageRating;
  final MovieFormat? format;
  final int? locationId;
  final int? fromYear;
  final int? toYear;

  const MovieSearchCriteria({
    this.titleQuery,
    this.directorQuery,
    this.genreQuery,
    this.ageRating,
    this.format,
    this.locationId,
    this.fromYear,
    this.toYear,
  });
}

@DriftDatabase(tables: [Movies, Locations])
class MovieDatabase extends _$MovieDatabase {
  MovieDatabase() : super(_openConnection());

  // Constructor for testing with in-memory database
  MovieDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  // Movie Operations
  Stream<List<Movie>> getAllMovies() => select(movies).watch();

  Future<Movie?> getMovie(int id) =>
      (select(movies)..where((m) => m.id.equals(id))).getSingleOrNull();

  Future<int> insertMovie(MoviesCompanion movie) => into(movies).insert(movie);

  Future<bool> updateMovie(Movie movie) {
    return update(movies).replace(movie);
  }

  Future<int> deleteMovie(int id) =>
      (delete(movies)..where((m) => m.id.equals(id))).go();

  // Search Operations
  Future<List<Movie>> searchMoviesByTitle(String searchTerm) {
    final query = select(movies)
      ..where((m) => m.title.lower().contains(searchTerm.toLowerCase()));
    return query.get();
  }

  Future<List<Movie>> searchMoviesByDirector(String searchTerm) {
    final query = select(movies)
      ..where((m) => m.director.lower().contains(searchTerm.toLowerCase()));
    return query.get();
  }

  Future<List<Movie>> searchMoviesByGenre(String searchTerm) {
    final query = select(movies)
      ..where((m) => m.genre.lower().contains(searchTerm.toLowerCase()));
    return query.get();
  }

  Future<List<Movie>> getMoviesByAgeRating(AgeRating rating) {
    final query = select(movies)..where((m) => m.ageRating.equals(rating.name));
    return query.get();
  }

  Future<List<Movie>> getMoviesByFormat(MovieFormat format) {
    final query = select(movies)..where((m) => m.format.equals(format.name));
    return query.get();
  }

  Future<List<Movie>> searchMovies(MovieSearchCriteria criteria) {
    final query = select(movies);

    // Build the where clause based on provided criteria
    Expression<bool> whereClause = const Constant(true);

    if (criteria.titleQuery != null && criteria.titleQuery!.isNotEmpty) {
      whereClause = whereClause &
          movies.title.lower().contains(criteria.titleQuery!.toLowerCase());
    }

    if (criteria.directorQuery != null && criteria.directorQuery!.isNotEmpty) {
      whereClause = whereClause &
          movies.director
              .lower()
              .contains(criteria.directorQuery!.toLowerCase());
    }

    if (criteria.genreQuery != null && criteria.genreQuery!.isNotEmpty) {
      whereClause = whereClause &
          movies.genre.lower().contains(criteria.genreQuery!.toLowerCase());
    }

    if (criteria.ageRating != null) {
      whereClause =
          whereClause & movies.ageRating.equals(criteria.ageRating!.name);
    }

    if (criteria.format != null) {
      whereClause = whereClause & movies.format.equals(criteria.format!.name);
    }

    if (criteria.locationId != null) {
      whereClause = whereClause &
          movies.locationId.isNotNull() &
          movies.locationId.equalsExp(Variable(criteria.locationId));
    }

    if (criteria.fromYear != null) {
      whereClause = whereClause &
          movies.releaseYear.isBiggerOrEqualValue(criteria.fromYear!);
    }

    if (criteria.toYear != null) {
      whereClause = whereClause &
          movies.releaseYear.isSmallerOrEqualValue(criteria.toYear!);
    }

    query.where((tbl) => whereClause);
    return query.get();
  }

  // Location Operations
  Stream<List<Location>> getAllLocations() => select(locations).watch();

  Future<Location?> getLocation(int id) =>
      (select(locations)..where((l) => l.id.equals(id))).getSingleOrNull();

  Future<int> insertLocation(LocationsCompanion location) =>
      into(locations).insert(location);

  Future<bool> updateLocation(Location location) =>
      update(locations).replace(location);

  Future<int> deleteLocation(int id) =>
      (delete(locations)..where((l) => l.id.equals(id))).go();

  // Get movies by location
  Future<List<Movie>> getMoviesByLocation(int locationId) =>
      (select(movies)..where((m) => m.locationId.equals(locationId))).get();

  // Provider for the database service
  // Note: Declared here as Provider.  If the database connection was to change
  // at some point (for example the database connection is reset and
  // reinitialised after a backup / restore) we would need to declare this as a
  // StateProvider instead.
  static final Provider<MovieDatabase> provider = Provider((ref) {
    final database = MovieDatabase();
    ref.onDispose(database.close);

    return database;
  });
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'movies.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
