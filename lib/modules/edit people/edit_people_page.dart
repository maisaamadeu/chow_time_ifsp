import 'package:chow_time_ifsp/modules/login/login_page.dart';
import 'package:chow_time_ifsp/shared/services/firebase_services.dart';
import 'package:chow_time_ifsp/shared/themes/app_colors.dart';
import 'package:chow_time_ifsp/shared/themes/app_images.dart';
import 'package:chow_time_ifsp/shared/themes/app_text_styles.dart';
import 'package:chow_time_ifsp/shared/widgets/accordion_card.dart';
import 'package:chow_time_ifsp/shared/widgets/label_button.dart';
import 'package:chow_time_ifsp/shared/widgets/people_delete_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditPeoplePage extends StatefulWidget {
  const EditPeoplePage({super.key});

  @override
  State<EditPeoplePage> createState() => _EditPeoplePageState();
}

class _EditPeoplePageState extends State<EditPeoplePage> {
  FirebaseServices _firebaseServices = FirebaseServices();
  List<QueryDocumentSnapshot>? studentsList = [];
  List<QueryDocumentSnapshot>? employeesList = [];
  List<QueryDocumentSnapshot> studentsToDelete = [];
  List<QueryDocumentSnapshot> employeesToDelete = [];

  @override
  void initState() {
    getPeopleList();
    super.initState();
  }

  Future<void> getPeopleList() async {
    studentsList = await _firebaseServices.getPeople(
      type: 'students',
    );
    employeesList = await _firebaseServices.getPeople(
      type: 'employees',
    );

    studentsList ??= await _firebaseServices.getPeople(
      type: 'students',
    );

    employeesList ??= await _firebaseServices.getPeople(
      type: 'employees',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Sair'),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'logout':
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                  break;
              }
            },
          )
        ],
      ),
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
                width: MediaQuery.of(context).size.width,
              ),
            ),

            //Elements of Page
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 400,
                    child: FutureBuilder(
                      future: getPeopleList(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );

                          default:
                            if (studentsList != null && employeesList != null) {
                              if (studentsList!.isEmpty &&
                                  employeesList!.isEmpty) {
                                return Center(
                                  child: Text(
                                      'Ocorreu um erro ao buscar os usúarios, contate a equipe técnica!'),
                                );
                              } else {
                                return SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Seja bem-vindo(a), adicione ou remova pessoas!',
                                        style: AppTextStyles.titleHome,
                                      ),
                                      AccordionCard(
                                        title: 'Estudantes',
                                        content: ListView.builder(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          itemCount: studentsList!.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return PeopleDeleteCard(
                                                onChanged: () {
                                                  if (studentsToDelete.contains(
                                                      studentsList![index])) {
                                                    studentsToDelete.remove(
                                                        studentsList![index]);
                                                  } else {
                                                    studentsToDelete.add(
                                                        studentsList![index]);
                                                  }

                                                  print(studentsToDelete);
                                                },
                                                registration:
                                                    (studentsList![index].data()
                                                                as Map)[
                                                            'registration']
                                                        .toString());
                                          },
                                        ),
                                      ),
                                      AccordionCard(
                                        title: 'Servidores',
                                        content: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: employeesList!.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return PeopleDeleteCard(
                                                onChanged: () {
                                                  if (employeesToDelete
                                                      .contains(employeesList![
                                                          index])) {
                                                    employeesToDelete.remove(
                                                        employeesList![index]);
                                                  } else {
                                                    employeesToDelete.add(
                                                        employeesList![index]);
                                                  }

                                                  print(employeesToDelete);
                                                },
                                                registration: (employeesList![
                                                                index]
                                                            .data()
                                                        as Map)['registration']
                                                    .toString());
                                          },
                                        ),
                                      ),
                                      LabelButton(
                                          labelText:
                                              'Apagar Pessoas Selecionadas',
                                          color: Colors.red,
                                          onPressed: () {
                                            if (employeesToDelete.isNotEmpty ||
                                                studentsToDelete.isNotEmpty) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Tem certeza?'),
                                                    content: const Text(
                                                        'Lembre-se, não é possível voltar atrás dessa decisão.'),
                                                    actions: [
                                                      TextButton(
                                                        child: const Text(
                                                          'Cancelar',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
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
                                                          if (employeesToDelete
                                                              .isNotEmpty) {
                                                            FirebaseServices()
                                                                .deleteMenuItems(
                                                                    employeesToDelete);
                                                            setState(() {});
                                                            employeesToDelete
                                                                .clear();
                                                          }

                                                          if (studentsToDelete
                                                              .isNotEmpty) {
                                                            FirebaseServices()
                                                                .deleteMenuItems(
                                                                    studentsToDelete);
                                                            setState(() {});
                                                            studentsToDelete
                                                                .clear();
                                                          }

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              showAlert(context);
                                            }
                                          }),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              return Center(
                                child: Text(
                                    'Ocorreu um erro ao buscar os usúarios, contate a equipe técnica!'),
                              );
                            }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ops!'),
          content: const Text(
              'Não é possível deletar pessoas se nenhuma estiver selecionada...'),
          actions: [
            TextButton(
              child: const Text('Selecionar pessoas'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
