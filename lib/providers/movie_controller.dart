import 'package:drift/drift.dart';
import 'package:mymoviedb/data/tables.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/database.dart';

part 'movie_controller.g.dart';

@riverpod
class MovieController extends _$MovieController {
  late final MovieDatabase _databaseService = ref.read(MovieDatabase.provider);

  @override
  Stream<List<Movie>> build() {
    //_databaseService = ref.read(MovieDatabase.provider);
    return _databaseService.getAllMovies();
  }

  Future<int> addMovie(
      String title,
      String director,
      int releaseYear,
      String genre,
      String? description,
      String? coverImagePath,
      MovieFormat format,
      AgeRating ageRating,
      int? locationId,
      [DateTime? addedDate]) async {
    return _databaseService.insertMovie(MoviesCompanion(
      title: Value(title),
      director: Value(director),
      releaseYear: Value(releaseYear),
      genre: Value(genre),
      description: Value(description),
      coverImagePath: Value(coverImagePath),
      format: Value(format),
      ageRating: Value(ageRating),
      locationId: Value(locationId),
      addedDate: Value(addedDate ?? DateTime.now()),
    ));
  }

  Future<bool> updateMovie(Movie movie) {
    Future<bool> ret = _databaseService.updateMovie(movie);
    //ref.invalidateSelf();
    return ret;
  }

  Future<int> deleteMovie(int id) async {
    return _databaseService.deleteMovie(id);
  }

  Future<Movie?> getMovie(int id) async {
    return _databaseService.getMovie(id);
  }
}
