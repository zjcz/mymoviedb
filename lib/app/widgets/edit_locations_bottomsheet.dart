import 'package:flutter/material.dart';
import 'package:mymoviedb/data/database.dart';

class EditLocationsBottomsheet extends StatefulWidget {
  final Location? location;
  final Function(Location) onSave;

  const EditLocationsBottomsheet(
      {super.key, required this.location, required this.onSave});

  @override
  State<EditLocationsBottomsheet> createState() =>
      _EditLocationsBottomsheetState();
}

class _EditLocationsBottomsheetState extends State<EditLocationsBottomsheet> {
  final locationNameController = TextEditingController();
  final locationDescController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.location != null) {
      locationNameController.text = widget.location!.name;
      locationDescController.text = widget.location!.description ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.location == null ? "Add Location" : "Edit Location",
              style: Theme.of(context).textTheme.headlineMedium),
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                      autofocus: true,
                      controller: locationNameController,
                      decoration:
                          const InputDecoration(labelText: "Location Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      }),
                ),
                Expanded(
                  child: TextFormField(
                      autofocus: true,
                      controller: locationDescController,
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      }),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle),
                  tooltip: 'Save',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      widget.onSave(Location(
                          id: widget.location?.id ?? 0,
                          name: locationNameController.text,
                          description: locationDescController.text,
                          createdAt: widget.location?.createdAt ?? DateTime.now()));
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.cancel),
                  tooltip: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
