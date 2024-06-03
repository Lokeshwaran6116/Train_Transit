import 'package:flutter/material.dart';

class StationDropdown extends StatefulWidget {
  final TextEditingController controller;
  final List<String> options;
  final void Function(String?)? onSelected;
  final String label;

  const StationDropdown({
    Key? key,
    required this.controller,
    required this.options,
    required this.label,
    this.onSelected,
  }) : super(key: key);

  @override
  _StationDropdownState createState() => _StationDropdownState();
}

class _StationDropdownState extends State<StationDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            return widget.options.where((String option) {
              return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String? selected) {
            setState(() {
              widget.controller.text = selected ?? '';
              if (widget.onSelected != null) {
                widget.onSelected!(selected);
              }
            });
          },
          fieldViewBuilder: (BuildContext context, TextEditingController fieldController, FocusNode fieldFocusNode, void Function() onFieldSubmitted) {
            return TextFormField(
              controller: fieldController,
              focusNode: fieldFocusNode,
              onFieldSubmitted: (_) => onFieldSubmitted(),
              decoration: InputDecoration(
                labelText: widget.label,
                filled: true,
                prefixIcon: Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 20), // Adjust the spacing between dropdown boxes
      ],
    );
  }
}
