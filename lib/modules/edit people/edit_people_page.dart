import 'package:chow_time_ifsp/shared/services/firebase_services.dart';
import 'package:chow_time_ifsp/shared/themes/app_colors.dart';
import 'package:chow_time_ifsp/shared/themes/app_images.dart';
import 'package:chow_time_ifsp/shared/themes/app_text_styles.dart';
import 'package:chow_time_ifsp/shared/widgets/accordion_card.dart';
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
  List<QueryDocumentSnapshot>? personToDelete = [];

  bool isDeleting = false;

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
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Seja bem-vindo(a), adicione ou remova pessoas!',
                                      style: AppTextStyles.titleHome,
                                    ),
                                    AccordionCard(
                                      title: 'Estudantes',
                                      content: ListView.builder(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        itemCount: studentsList!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            ListTile(
                                          title: Text(
                                            (studentsList![index].data()
                                                    as Map)['registration']
                                                .toString(),
                                          ),
                                          trailing: isDeleting
                                              ? Checkbox(
                                                  value: false,
                                                  onChanged: (value) {},
                                                )
                                              : Container(),
                                        ),
                                      ),
                                    ),
                                    AccordionCard(
                                      title: 'Servidores',
                                      content: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: employeesList!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            Text(index.toString()),
                                      ),
                                    ),
                                  ],
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
}
// Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Seja bem-vindo(a), envie ou remova pessoas!',
//                             style: AppTextStyles.titleHome,
//                           ),
//                           AccordionCard(
//                             title: 'Estudantes',
//                             content: [
//                               Text('A'),
//                             ],
//                           ),
//                           AccordionCard(
//                             title: 'Servidores',
//                             content: [
//                               Text('A'),
//                             ],
//                           ),
//                         ],
//                       ),
