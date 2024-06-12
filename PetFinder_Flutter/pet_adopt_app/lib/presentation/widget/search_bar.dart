import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String labelText;
  final TextEditingController controller;

  const SearchBarWidget(
      {super.key,
      this.onChanged,
      this.labelText = 'Search',
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5),
      child: SizedBox(
        height: 40.0,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          ),
        ),
      ),
    );
  }
}
