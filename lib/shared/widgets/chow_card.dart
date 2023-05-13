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
      this.onPressed});

  final String? mainCourse;
  final String? salad;
  final String? fruit;
  final bool isEmployee;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        title: Text(
          '22/05/2022',
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
              isEmployee ? const TextSpan(text: 'Alunos: 1') : TextSpan(),
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
