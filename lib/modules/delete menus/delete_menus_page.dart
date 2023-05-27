import 'package:chow_time_ifsp/modules/home/home_page.dart';
import 'package:chow_time_ifsp/shared/services/firebase_services.dart';
import 'package:chow_time_ifsp/shared/themes/app_colors.dart';
import 'package:chow_time_ifsp/shared/themes/app_images.dart';
import 'package:chow_time_ifsp/shared/themes/app_text_styles.dart';
import 'package:chow_time_ifsp/shared/widgets/label_button.dart';
import 'package:chow_time_ifsp/shared/widgets/menu_delete_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteMenusPage extends StatefulWidget {
  const DeleteMenusPage({super.key, required this.firebaseServices});
  final FirebaseServices firebaseServices;

  @override
  State<DeleteMenusPage> createState() => _DeleteMenusPageState();
}

class _DeleteMenusPageState extends State<DeleteMenusPage> {
  List<DocumentSnapshot> deleteMenus = [];

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ops!'),
          content: const Text(
              'Não é possível apagar alguma semana se nenhuma estiver selecionada...'),
          actions: [
            TextButton(
              child: const Text('Selecionar semanas'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
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
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 400,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('menus')
                            .orderBy('start_of_the_week')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Erro ao carregar os menus');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasData) {
                            List<DocumentSnapshot> menuDocs =
                                snapshot.data!.docs;
                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //Title
                                  Text(
                                    'Selecione as semanas abaixo que gostaria de apagar:',
                                    style: AppTextStyles.titleRegular,
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),

                                  Flexible(
                                    child: ListView.builder(
                                      itemCount: menuDocs.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        Map<String, dynamic> menuData =
                                            menuDocs[index].data()
                                                as Map<String, dynamic>;

                                        return MenuDeleteCard(
                                          startOfTheWeek:
                                              menuData['start_of_the_week'],
                                          endOfTheWeek:
                                              menuData['end_of_the_week'],
                                          onChanged: () {
                                            addMenuToDelete(menuDocs[index]);
                                          },
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 25,
                                  ),
                                  LabelButton(
                                      labelText: 'Apagar Semanas Selecionadas',
                                      color: Colors.red,
                                      onPressed: () {
                                        if (deleteMenus.isEmpty) {
                                          showAlert(context);
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Tem certeza?'),
                                                content: const Text(
                                                    'Lembre-se, não é possível voltar atrás dessa decisão.'),
                                                actions: [
                                                  TextButton(
                                                    child: const Text(
                                                      'Cancelar',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text(
                                                        'Sim, tenho certeza!'),
                                                    onPressed: () {
                                                      FirebaseServices()
                                                          .deleteMenuItems(
                                                              deleteMenus);
                                                      Navigator.pop(context);
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              HomePage(
                                                                  firebaseServices:
                                                                      widget
                                                                          .firebaseServices),
                                                        ),
                                                        (route) => false,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      })
                                ],
                              ),
                            );
                          }

                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addMenuToDelete(DocumentSnapshot doc) {
    if (deleteMenus.contains(doc)) {
      deleteMenus.remove(doc);
    } else {
      deleteMenus.add(doc);
    }
  }
}
