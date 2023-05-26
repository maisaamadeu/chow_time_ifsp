import 'package:chow_time_ifsp/shared/themes/app_colors.dart';
import 'package:chow_time_ifsp/shared/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChowCard extends StatefulWidget {
  const ChowCard(
      {super.key,
      this.mainCourse,
      this.salad,
      this.fruit,
      required this.isEmployee,
      this.onPressed,
      required this.index,
      required this.date,
      this.students,
      required this.id,
      required this.containsStudent});

  final String? mainCourse;
  final String? salad;
  final String? fruit;
  final String date;
  final String? students;
  final bool containsStudent;
  final int index;
  final bool isEmployee;
  final VoidCallback? onPressed;
  final String id;

  @override
  State<ChowCard> createState() => _ChowCardState();
}

class _ChowCardState extends State<ChowCard> {
  late bool isPassed;

  @override
  void initState() {
    super.initState();

    isPassed = hasPassedDate(widget.date);
  }

  bool hasPassedDate(String date) {
    DateTime currentDate = DateTime.now();
    DateTime providedDate = DateFormat('dd/MM/yyyy').parse(date);

    if (currentDate.year == providedDate.year &&
        currentDate.month == providedDate.month &&
        currentDate.day > providedDate.day) {
      return true;
    } else if (currentDate.year == providedDate.year &&
        currentDate.month == providedDate.month &&
        currentDate.day == providedDate.day &&
        currentDate.hour >= 8 &&
        currentDate.minute >= 30) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mainCourse == null &&
        widget.salad == null &&
        widget.fruit == null) {
      return Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          title: Text(
            widget.date,
            style: AppTextStyles.titleListTile,
          ),
          subtitle: Text(
            !isPassed
                ? 'Nada foi informado até o momento!'
                : 'Nada foi informado neste dia!',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.delete,
            ),
          ),
          trailing: !isPassed
              ? widget.isEmployee
                  ? IconButton(
                      onPressed: widget.onPressed ?? () {},
                      icon: const Icon(
                        Icons.edit,
                        color: AppColors.delete,
                      ),
                    )
                  : null
              : null,
        ),
      );
    } else {
      return Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          title: Text(
            widget.date,
            style: AppTextStyles.titleListTile,
          ),
          subtitle: RichText(
            text: TextSpan(
              style: AppTextStyles.trailingRegular,
              children: <TextSpan>[
                const TextSpan(
                  text: 'Prato Principal: ',
                ),
                TextSpan(
                  text: '${widget.mainCourse}\n',
                ),
                const TextSpan(
                  text: 'Salada: ',
                ),
                TextSpan(
                  text: '${widget.salad}\n',
                ),
                const TextSpan(
                  text: 'Fruta: ',
                ),
                TextSpan(
                  text: '${widget.fruit}\n',
                ),
                widget.isEmployee
                    ? TextSpan(text: 'Alunos: ${widget.students.toString()}')
                    : const TextSpan(),
              ],
            ),
          ),
          trailing: !isPassed
              ? IconButton(
                  onPressed: widget.onPressed ?? () {},
                  icon: widget.isEmployee
                      ? const Icon(
                          Icons.edit,
                          color: AppColors.primary,
                        )
                      : widget.containsStudent
                          ? const Icon(
                              Icons.done,
                              color: AppColors.primary,
                            )
                          : const Icon(
                              Icons.close,
                              color: AppColors.delete,
                            ),
                )
              : null,
        ),
      );
    }
  }
}
