import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mymoviedb/app/widgets/delete_confirmation_dialog.dart';

void main() {
  testWidgets('DeleteConfirmationDialog displays correctly',
      (WidgetTester tester) async {
    bool deleteConfirmed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeleteConfirmationDialog(
            onConfirmDelete: () {
              deleteConfirmed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Remove this Item?'), findsOneWidget);
    expect(find.text('Are you sure you want to remove this item?'),
        findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(deleteConfirmed, isTrue);
  });

  testWidgets('DeleteConfirmationDialog cancel button works',
      (WidgetTester tester) async {
    bool deleteConfirmed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeleteConfirmationDialog(
            onConfirmDelete: () {
              deleteConfirmed = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(deleteConfirmed, isFalse);
  });
}
