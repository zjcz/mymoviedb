//import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:mymoviedb/app/widgets/edit_locations_bottomsheet.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mymoviedb/app/widgets/delete_confirmation_dialog.dart';
import 'package:mymoviedb/data/database.dart';
import 'package:mymoviedb/providers/location_controller.dart';

/// This screen allows the user to view, add, edit and delete locations.
/// Data access is done through the DatabaseService provider.
/// Locations are added / edited through a popup bottom sheet (see showAddEditBottomSheet() method)
class ListLocationsScreen extends ConsumerStatefulWidget {
  const ListLocationsScreen({super.key});

  @override
  ConsumerState<ListLocationsScreen> createState() =>
      _ListLocationsScreenState();
}

class _ListLocationsScreenState extends ConsumerState<ListLocationsScreen> {
  @override
  Widget build(BuildContext context) {
    final currentLocations = ref.watch(locationControllerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Manage Locations'), actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              showAddEditBottomSheet(context, null);
            },
          ),
        ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: currentLocations.when(
                  data: (locations) {
                    return ListView.builder(
                        itemCount: locations.length,
                        itemBuilder: (context, index) {
                          final location = locations[index];
                          return ListTile(
                            title: Text(location.name),
                            subtitle: location.description != null
                                ? Text(location.description!)
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    showAddEditBottomSheet(context, location);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    showAdaptiveDialog(
                                        context: context,
                                        builder: (_) =>
                                            DeleteConfirmationDialog(
                                                title: 'Remove this Location?',
                                                content:
                                                    'Are you sure you want to remove this location?',
                                                onConfirmDelete: () async {
                                                  ref
                                                      .read(
                                                          locationControllerProvider
                                                              .notifier)
                                                      .deleteLocation(
                                                          location.id);
                                                }));
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  error: (e, s) {
                    debugPrintStack(label: e.toString(), stackTrace: s);
                    return Center(
                        child: Text('Error loading data: ${e.toString()}'));
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// This shows an edit popup at the bottom of the screen, containing a single
  /// field to allow the user to add or edit the category name.
  void showAddEditBottomSheet(BuildContext context, Location? location) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return EditLocationsBottomsheet(
            location: location,
            onSave: (location) {
              if (location.id == 0) {
                ref
                    .read(locationControllerProvider.notifier)
                    .addLocation(location.name, location.description);
              } else {
                ref
                    .read(locationControllerProvider.notifier)
                    .updateLocation(location);
              }
              Navigator.pop(context);
            });
      },
    );
  }
}
