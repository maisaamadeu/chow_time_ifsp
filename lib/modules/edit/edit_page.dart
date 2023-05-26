import 'package:chow_time_ifsp/shared/services/firebase_services.dart';
import 'package:chow_time_ifsp/shared/themes/app_colors.dart';
import 'package:chow_time_ifsp/shared/themes/app_images.dart';
import 'package:chow_time_ifsp/shared/themes/app_text_styles.dart';
import 'package:chow_time_ifsp/shared/widgets/input_data.dart';
import 'package:chow_time_ifsp/shared/widgets/label_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditPage extends StatefulWidget {
  const EditPage(
      {super.key,
      this.mainCourse,
      this.salad,
      this.fruit,
      required this.id,
      required this.index});

  final String? mainCourse;
  final String? salad;
  final String? fruit;
  final int index;
  final String id;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController mainCourseController = TextEditingController();
  TextEditingController fruitController = TextEditingController();
  TextEditingController saladController = TextEditingController();
  FirebaseServices firebaseServices = FirebaseServices();
  bool isMainCourseError = false;
  bool isSaladError = false;
  bool isFruitError = false;

  @override
  void initState() {
    mainCourseController.text = widget.mainCourse.toString();
    fruitController.text = widget.fruit.toString();
    saladController.text = widget.salad.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            //Background
            Positioned(
              bottom: 0,
              child: SvgPicture.asset(
                AppImages.background,
                semanticsLabel: 'Background Wave',
              ),
            ),

            //Elements of Page
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Edite as informações abaixo do cardápio selecionado',
                      style: AppTextStyles.titleRegular,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputData(
                      labelText: 'Prato Principal',
                      controller: mainCourseController,
                      isError: isMainCourseError,
                      errorText: '',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputData(
                      labelText: 'Salad',
                      controller: saladController,
                      isError: isSaladError,
                      errorText: '',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputData(
                      labelText: 'Fruit',
                      controller: fruitController,
                      isError: isFruitError,
                      errorText: '',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: LabelButton(
                          labelText: 'Salvar',
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Tem certeza?'),
                                    content: const Text(
                                        'Lembre-se, não é possível voltar atrás dessa decisão.'),
                                    actions: [
                                      TextButton(
                                        child: const Text(
                                          'Cancelar',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child:
                                            const Text('Sim, tenho certeza!'),
                                        onPressed: () async {
                                          await firebaseServices.editMenu(
                                              documentID: widget.id,
                                              index: widget.index,
                                              fruit: fruitController.text,
                                              mainCourse:
                                                  mainCourseController.text,
                                              salad: saladController.text);
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: LabelButton(
                            labelText: 'Cancelar',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: AppColors.delete,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
