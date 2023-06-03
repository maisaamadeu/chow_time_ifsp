import 'package:flutter/material.dart';

class PeopleDeleteCard extends StatefulWidget {
  final String registration;
  final Function() onChanged;

  const PeopleDeleteCard({
    super.key,
    required this.onChanged,
    required this.registration,
  });

  @override
  State<PeopleDeleteCard> createState() => _MenuDeleteCardState();
}

class _MenuDeleteCardState extends State<PeopleDeleteCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isChecked,
        onChanged: (value) {
          widget.onChanged();
          setState(() {
            isChecked = value!;
          });
        },
      ),
      title: Text('Prontuário: ${widget.registration}'),
    );
  }
}
