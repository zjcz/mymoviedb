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

  Future<int> addMovie(MoviesCompanion movie) async {
    return _databaseService.insertMovie(movie);
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
