import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenuDeleteCard extends StatefulWidget {
  final Timestamp startOfTheWeek;
  final Timestamp endOfTheWeek;
  final Function() onChanged;

  const MenuDeleteCard({
    super.key,
    required this.startOfTheWeek,
    required this.endOfTheWeek,
    required this.onChanged,
  });

  @override
  State<MenuDeleteCard> createState() => _MenuDeleteCardState();
}

class _MenuDeleteCardState extends State<MenuDeleteCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    final formattedStartOfTheWeek =
        dateFormat.format(widget.startOfTheWeek.toDate());
    final formattedEndOfTheWeek =
        dateFormat.format(widget.endOfTheWeek.toDate());

    return Card(
      child: ListTile(
        leading: Checkbox(
          value: isChecked,
          onChanged: (value) {
            widget.onChanged();
            setState(() {
              isChecked = value!;
            });
          },
        ),
        title: Text('Início da Semana: $formattedStartOfTheWeek'),
        subtitle: Text('Fim da Semana: $formattedEndOfTheWeek'),
      ),
    );
  }
}
