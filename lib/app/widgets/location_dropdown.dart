import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mymoviedb/data/database.dart';
import 'package:mymoviedb/providers/location_controller.dart';

class LocationDropdown extends ConsumerWidget {
  final int? locationId;
  final Function(Location?) onChanged;
  final String noneNodeText;

  const LocationDropdown(
      {super.key,
      this.locationId,
      required this.onChanged,
      this.noneNodeText = '(none)'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsList = ref.watch(locationControllerProvider);

    return locationsList.when(
      data: (locations) {
        return DropdownButtonFormField<Location?>(
            decoration: const InputDecoration(labelText: "Location"),
            value: locationId == null
                ? null
                : locations.where((c) => c.id == locationId).first,
            items: [
              DropdownMenuItem<Location?>(
                key: const Key('none'),
                value: null,
                child: Text(noneNodeText),
              ),
              ...locations.map((c) {
                return DropdownMenuItem<Location?>(
                  key: Key(c.id.toString()),
                  value: c,
                  child: Text(c.name),
                );
              })
            ],
            onChanged: onChanged);
      },
      error: (e, s) {
        debugPrintStack(label: e.toString(), stackTrace: s);
        return Center(child: Text('Error loading data: ${e.toString()}'));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
