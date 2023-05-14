import 'package:chow_time_ifsp/shared/themes/app_colors.dart';
import 'package:chow_time_ifsp/shared/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class ChowCard extends StatelessWidget {
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
      required this.id});

  final String? mainCourse;
  final String? salad;
  final String? fruit;
  final String date;
  final String? students;
  final int index;
  final bool isEmployee;
  final VoidCallback? onPressed;
  final String id;

  @override
  Widget build(BuildContext context) {
    if (mainCourse == null && salad == null && fruit == null) {
      return Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          title: Text(
            date,
            style: AppTextStyles.titleListTile,
          ),
          subtitle: const Text(
            'Nada foi informado até o momento!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.delete,
            ),
          ),
          trailing: isEmployee
              ? IconButton(
                  onPressed: onPressed ?? () {},
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.delete,
                  ),
                )
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
            date,
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
                  text: '$mainCourse\n',
                ),
                const TextSpan(
                  text: 'Salada: ',
                ),
                TextSpan(
                  text: '$salad\n',
                ),
                const TextSpan(
                  text: 'Fruta: ',
                ),
                TextSpan(
                  text: '$fruit\n',
                ),
                isEmployee
                    ? TextSpan(text: 'Alunos: ${students.toString()}')
                    : const TextSpan(),
              ],
            ),
          ),
          trailing: IconButton(
            onPressed: onPressed ?? () {},
            icon: isEmployee
                ? const Icon(
                    Icons.edit,
                    color: AppColors.primary,
                  )
                : const Icon(
                    Icons.done,
                    color: AppColors.primary,
                  ),
          ),
        ),
      );
    }
  }
}
