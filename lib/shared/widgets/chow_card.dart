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
      required this.containsStudent,
      this.lastIndex});

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
  final bool? lastIndex;

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

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ops!'),
          content: const Text(
              'Infelizmente acabou o tempo para selecionar se irá comer ou não!'),
          actions: [
            TextButton(
              child: const Text('Voltar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool hasPassedDate(String date) {
    DateTime currentDate = DateTime.now();
    DateTime providedDate = DateFormat('dd/MM/yyyy - HH:mm:ss').parse(date);

    // print("Data Atual: $currentDate\nData Provida: $providedDate\nJá passou: ${currentDate.isAfter(providedDate)}\n-------");

    if (currentDate.isAfter(providedDate)) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mainCourse == null ||
        widget.mainCourse == '' ||
        widget.salad == null ||
        widget.salad == '' ||
        widget.fruit == null ||
        widget.fruit == '') {
      return Column(
        children: [
          Card(
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
                    ? 'Nada foi informado até o momento ou está incompleto!'
                    : 'Nada foi informado neste dia!',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.delete,
                ),
              ),
              trailing: isPassed
                  ? null
                  : widget.isEmployee
                      ? IconButton(
                          onPressed: widget.onPressed ?? () {},
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.delete,
                          ),
                        )
                      : null,
            ),
          ),
          widget.lastIndex == true
              ? Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Produzido com amor pelos alunos de Redes 3 de 2023: Maísa, Hallisson e Gabriel ❤️❤️❤️',
                    style: AppTextStyles.trailingRegular,
                  ),
                )
              : Container()
        ],
      );
    } else {
      return Column(
        children: [
          Card(
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
                        ? TextSpan(
                            text: 'Alunos: ${widget.students.toString()}')
                        : const TextSpan(),
                  ],
                ),
              ),
              trailing: !isPassed
                  ? widget.isEmployee
                      ? IconButton(
                          onPressed: widget.onPressed ?? () {},
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.primary,
                          ))
                      : Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                            value: widget.containsStudent,
                            onChanged: (value) {
                              if (hasPassedDate(widget.date)) {
                                showAlert(context);
                                return;
                              }
                              widget.onPressed!();
                            },
                          ),
                        )
                  : null,
            ),
          ),
          widget.lastIndex == true
              ? Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Produzido com amor pelos alunos de Redes 3 de 2023: Maísa e Hallisson ❤️❤️❤️',
                    style: AppTextStyles.trailingRegular,
                  ),
                )
              : Container()
        ],
      );
    }
  }
}
