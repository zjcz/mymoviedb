import 'package:drift/drift.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/database.dart';

part 'location_controller.g.dart';

@riverpod
class LocationController extends _$LocationController {
  late final MovieDatabase _databaseService = ref.read(MovieDatabase.provider);

  @override
  Stream<List<Location>> build() {
    return _databaseService.getAllLocations();
  }

  Future<int> addLocation(String name, String? description) async {
    return _databaseService.insertLocation(LocationsCompanion(
      name: Value(name),
      description: Value(description),
    ));
  }

  Future<bool> updateLocation(Location location) async {
    return _databaseService.updateLocation(location);
  }

  Future<int> deleteLocation(int id) async {
    return _databaseService.deleteLocation(id);
  }
}

@riverpod
Future<Location?> getLocation(Ref ref, int id) {
  return ref.watch(MovieDatabase.provider).getLocation(id);
}

@riverpod
Future<String> getLocationName(Ref ref, int id) async {
  final location = await ref.watch(getLocationProvider(id).future);
  return location?.name ?? 'Unknown Location';
}
