import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mymoviedb/app/widgets/edit_locations_bottomsheet.dart';
import 'package:mymoviedb/data/database.dart';

void main() {
  testWidgets('EditLocationsBottomsheet displays correctly',
      (WidgetTester tester) async {
    // Create a mock location
    final location = Location(
        id: 1,
        name: 'Test Location',
        description: 'Test Description',
        createdAt: DateTime.now());

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EditLocationsBottomsheet(
          location: location,
          onSave: (Location loc) {},
        ),
      ),
    ));

    // Verify the widget displays the correct title
    expect(find.text('Edit Location'), findsOneWidget);

    // Verify the text fields contain the correct initial values
    expect(find.text('Test Location'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });

  testWidgets('EditLocationsBottomsheet saves location',
      (WidgetTester tester) async {
    // Create a mock location
    final location = Location(
        id: 1,
        name: 'Test Location',
        description: 'Test Description',
        createdAt: DateTime.now());

    // Variable to store the saved location
    Location? savedLocation;

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EditLocationsBottomsheet(
          location: location,
          onSave: (Location loc) {
            savedLocation = loc;
          },
        ),
      ),
    ));

    // Enter new values into the text fields
    await tester.enterText(
        find.byType(TextFormField).at(0), 'New Location Name');
    await tester.enterText(find.byType(TextFormField).at(1), 'New Description');

    // Tap the save button
    await tester.tap(find.byIcon(Icons.check_circle));
    await tester.pump();

    // Verify the location was saved with the new values
    expect(savedLocation, isNotNull);
    expect(savedLocation!.name, 'New Location Name');
    expect(savedLocation!.description, 'New Description');
  });

  testWidgets('EditLocationsBottomsheet cancels without saving',
      (WidgetTester tester) async {
    // Create a mock location
    final location = Location(
        id: 1,
        name: 'Test Location',
        description: 'Test Description',
        createdAt: DateTime.now());

    // Variable to store the saved location
    Location? savedLocation;

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EditLocationsBottomsheet(
          location: location,
          onSave: (Location loc) {
            savedLocation = loc;
          },
        ),
      ),
    ));

    // Tap the cancel button
    await tester.tap(find.byIcon(Icons.cancel));
    await tester.pump();

    // Verify the location was not saved
    expect(savedLocation, isNull);
  });
}
