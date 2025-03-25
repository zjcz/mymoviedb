import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mymoviedb/app/widgets/location_dropdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mymoviedb/data/database.dart';

import '../../providers/location_controller_test.mocks.dart';

final _formKey = GlobalKey<FormState>();
const String key = 'location_dropdown';

// Test the location dropdown widget
// Note - rather than mocking the provider we mock the database service the
// provider gets its data from, as advised in the Riverpod documentation
// https://riverpod.dev/docs/essentials/testing#mocking-notifiers
@GenerateNiceMocks([MockSpec<MovieDatabase>()])
void main() {
  group('Test building dropdown', () {
    testWidgets('show the widget with no location record', (tester) async {
      MockMovieDatabase databaseService = MockMovieDatabase();
      when(databaseService.getAllLocations())
          .thenAnswer((_) => Stream.value([]));

      await tester.pumpWidget(createDropdown(databaseService, null, (_) {}));
      await tester.pumpAndSettle();

      expect(find.text("Location"), findsOneWidget);
      expect(find.byType(LocationDropdown), findsOneWidget);
      verify(databaseService.getAllLocations()).called(1);
    });

    testWidgets('show the dropdown with location record', (tester) async {
      int id = 5;
      String locationName = 'new location';
      String locationDescription = 'new location description';
      final location = Location(
        id: id,
        name: locationName,
        description: locationDescription,
        createdAt: DateTime.now(),
      );

      final databaseService = MockMovieDatabase();
      when(databaseService.getAllLocations())
          .thenAnswer((_) => Stream.value([location]));

      await tester.pumpWidget(createDropdown(databaseService, null, (_) {}));
      await tester.pumpAndSettle();

      verify(databaseService.getAllLocations()).called(1);
      expect(find.text("Location"), findsOneWidget);
      expect(find.byType(LocationDropdown), findsOneWidget);
    });

    testWidgets('is the location record selectable', (tester) async {
      int id = 5;
      String locationName = 'new location';
      String locationDescription = 'new location description';
      final location = Location(
        id: id,
        name: locationName,
        description: locationDescription,
        createdAt: DateTime.now(),
      );
      Location? onSelectionChangedValue;
      bool onSelectionChangedCalled = false;

      onSelectionChanged(Location? value) {
        onSelectionChangedValue = value;
        onSelectionChangedCalled = true;
      }

      final databaseService = MockMovieDatabase();
      when(databaseService.getAllLocations())
          .thenAnswer((_) => Stream.value([location]));

      await tester.pumpWidget(
          createDropdown(databaseService, null, onSelectionChanged));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LocationDropdown));
      await tester.pumpAndSettle();
      await tester.tap(
          find.widgetWithText(DropdownMenuItem<Location?>, locationName).last);
      await tester.pump();

      expect(onSelectionChangedValue?.id, equals(id));
      expect(onSelectionChangedCalled, isTrue);
    });

    testWidgets('is the [none] location record selectable', (tester) async {
      int id = 5;
      String locationName = 'new location';
      String locationDescription = 'new location description';
      String noneLocationName = '[ - None - ]';
      final location = Location(
        id: id,
        name: locationName,
        description: locationDescription,
        createdAt: DateTime.now(),
      );
      Location? onSelectionChangedValue;
      bool onSelectionChangedCalled = false;

      onSelectionChanged(Location? value) {
        onSelectionChangedValue = value;
        onSelectionChangedCalled = true;
      }

      final databaseService = MockMovieDatabase();
      when(databaseService.getAllLocations())
          .thenAnswer((_) => Stream.value([location]));

      await tester.pumpWidget(createDropdown(
          databaseService, null, onSelectionChanged, noneLocationName));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LocationDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find
          .widgetWithText(DropdownMenuItem<Location?>, noneLocationName)
          .last);
      await tester.pump();

      expect(onSelectionChangedValue, isNull);
      expect(onSelectionChangedCalled, isTrue);
    });

    testWidgets('specified location is pre selected', (tester) async {
      int id1 = 1;
      String locationName1 = 'new location one';
      String locationDescription1 = 'new location description 1';
      final location1 = Location(
        id: id1,
        name: locationName1,
        description: locationDescription1,
        createdAt: DateTime.now(),
      );
      int id2 = 2;
      String locationName2 = 'location two';
      String locationDescription2 = 'location description 2';
      final location2 = Location(
        id: id2,
        name: locationName2,
        description: locationDescription2,
        createdAt: DateTime.now(),
      );
      int id3 = 3;
      String locationName3 = 'location three';
      String locationDescription3 = 'location description 3';
      final location3 = Location(
        id: id3,
        name: locationName3,
        description: locationDescription3,
        createdAt: DateTime.now(),
      );
      int selectedLocationId = 2;

      onSelectionChanged(Location? value) {}

      final databaseService = MockMovieDatabase();
      when(databaseService.getAllLocations())
          .thenAnswer((_) => Stream.value([location1, location2, location3]));

      await tester.pumpWidget(createDropdown(
          databaseService, selectedLocationId, onSelectionChanged));
      await tester.pumpAndSettle();

      expect(find.text(locationName1), findsNothing);
      expect(find.text(locationName2), findsOneWidget);
      expect(find.text(locationName3), findsNothing);
      verify(databaseService.getAllLocations()).called(1);
    });
  });
}

/// Create the widget for testing
Widget createDropdown(
    MockMovieDatabase db, int? locationId, Function(Location?) onChanged,
    [String noneNodeText = '(none)']) {
  return ProviderScope(
    overrides: [
      MovieDatabase.provider.overrideWithValue(db),
    ],
    child: MaterialApp(
        home: Scaffold(
            body: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: LocationDropdown(
                    key: const Key(key),
                    locationId: locationId,
                    onChanged: onChanged,
                    noneNodeText: noneNodeText)))),
  );
}
