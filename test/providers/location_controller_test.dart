import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';
import 'package:mymoviedb/data/database.dart';
import 'package:mymoviedb/providers/location_controller.dart';

@GenerateNiceMocks([MockSpec<MovieDatabase>()])
import 'location_controller_test.mocks.dart';

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

  group('LocationController Tests', () {
    test('build returns empty list initially', () async {
      when(mockDb.getAllLocations()).thenAnswer((_) => Stream.value([]));

      final locations = await container.read(locationControllerProvider.future);
      expect(locations, isEmpty);
      verify(mockDb.getAllLocations()).called(1);
    });

    test('addLocation calls database insert', () async {
      final controller = container.read(locationControllerProvider.notifier);

      final location = LocationsCompanion.insert(
        name: 'Test Location',
        description: const Value('Test Description'),
      );

      when(mockDb.insertLocation(location)).thenAnswer((_) async => 1);

      final id = await controller.addLocation(
          location.name.value, location.description.value);
      expect(id, equals(1));
      verify(mockDb.insertLocation(location)).called(1);
    });

    test('updateLocation calls database update', () async {
      final controller = container.read(locationControllerProvider.notifier);

      final location = Location(
        id: 1,
        name: 'Updated Name',
        description: 'Test Description',
        createdAt: DateTime.now(),
      );

      when(mockDb.updateLocation(location)).thenAnswer((_) async => true);

      final success = await controller.updateLocation(location);
      expect(success, isTrue);
      verify(mockDb.updateLocation(location)).called(1);
    });

    test('deleteLocation calls database delete', () async {
      final controller = container.read(locationControllerProvider.notifier);

      when(mockDb.deleteLocation(1)).thenAnswer((_) async => 1);

      final deletedCount = await controller.deleteLocation(1);
      expect(deletedCount, equals(1));
      verify(mockDb.deleteLocation(1)).called(1);
    });

    test('location provider calls database getLocation', () async {
      when(mockDb.getLocation(1)).thenAnswer((_) async => Location(
            id: 1,
            name: 'Test Location',
            description: 'Test Description',
            createdAt: DateTime.now(),
          ));

      final location = await container.read(getLocationProvider(1).future);
      expect(location?.name, equals('Test Location'));
      verify(mockDb.getLocation(1)).called(1);
    });

    test('locationName provider returns location name', () async {
      when(mockDb.getLocation(1)).thenAnswer((_) async => Location(
            id: 1,
            name: 'Test Location',
            description: 'Test Description',
            createdAt: DateTime.now(),
          ));

      final name = await container.read(getLocationNameProvider(1).future);
      expect(name, equals('Test Location'));
      verify(mockDb.getLocation(1)).called(1);
    });

    test('locationName provider returns Unknown Location for null', () async {
      when(mockDb.getLocation(1)).thenAnswer((_) async => null);

      final name = await container.read(getLocationNameProvider(1).future);
      expect(name, equals('Unknown Location'));
      verify(mockDb.getLocation(1)).called(1);
    });
  });
}
