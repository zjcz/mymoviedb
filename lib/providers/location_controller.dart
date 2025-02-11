import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/database.dart';

part 'location_controller.g.dart';

@riverpod
class LocationController extends _$LocationController {
  late final MovieDatabase _databaseService = ref.read(MovieDatabase.provider);

  @override
  Stream<List<Location>> build() {
    //_databaseService = ref.read(MovieDatabase.provider);
    return _databaseService.getAllLocations();
  }

  Future<int> addLocation(LocationsCompanion location) async {
    return _databaseService.insertLocation(location);
  }

  Future<bool> updateLocation(Location location) async {
    return _databaseService.updateLocation(location);
  }

  Future<int> deleteLocation(int id) async {
    return _databaseService.deleteLocation(id);
  }
}

@riverpod
Future<Location?> location(Ref ref, int id) {
  return ref.watch(MovieDatabase.provider).getLocation(id);
}

@riverpod
Future<String> locationName(Ref ref, int id) async {
  final location = await ref.watch(locationProvider(id).future);
  return location?.name ?? 'Unknown Location';
}
