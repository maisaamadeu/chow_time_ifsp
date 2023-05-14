import 'package:chow_time_ifsp/modules/edit/edit_page.dart';
import 'package:chow_time_ifsp/shared/services/firebase_services.dart';
import 'package:chow_time_ifsp/shared/themes/app_colors.dart';
import 'package:chow_time_ifsp/shared/themes/app_images.dart';
import 'package:chow_time_ifsp/shared/themes/app_text_styles.dart';
import 'package:chow_time_ifsp/shared/widgets/chow_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.firebaseServices});

  final FirebaseServices firebaseServices;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: AppColors.primary,
        onRefresh: () async {
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: SingleChildScrollView(
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

                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).width * 0.2,
                        ),
                        Text(
                          'Seja bem-vindo(a) ${widget.firebaseServices.user!.firstName} ${widget.firebaseServices.user!.lastName}!',
                          style: AppTextStyles.titleHome,
                        ),
                        Text(
                          'Selecione abaixo se irá comser ou não!',
                          style: AppTextStyles.trailingRegular,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FutureBuilder<bool>(
                          future: widget.firebaseServices.getMenu(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                snapshot.connectionState ==
                                    ConnectionState.none) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              if (snapshot.hasError) {
                                return const Text('Erro ao carregar o menu.');
                              } else {
                                if (snapshot.data!) {
                                  String currentMenuID =
                                      widget.firebaseServices.currentMenu!.id;
                                  List<dynamic> currentMenu = (widget
                                      .firebaseServices.currentMenu!
                                      .data() as Map)['menu_days'];
                                  List<dynamic> currentMenuDays =
                                      widget.firebaseServices.currentMenuDays;

                                  print((widget.firebaseServices.currentMenu!
                                      .data()
                                      .runtimeType));

                                  if (widget.firebaseServices.user!.userType ==
                                      'student') {
                                    return Expanded(
                                      child: ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: currentMenuDays.length,
                                        padding: const EdgeInsets.all(0),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            ChowCard(
                                          isEmployee: false,
                                          fruit: currentMenuDays[index]
                                              ['fruit'],
                                          mainCourse: currentMenuDays[index]
                                              ['main_course'],
                                          salad: currentMenuDays[index]
                                              ['salad'],
                                          onPressed: () {
                                            print('Estou funcionando');
                                          },
                                          index: index,
                                          date: DateFormat('dd/MM/yyyy').format(
                                              (currentMenuDays[index]['date']
                                                      as Timestamp)
                                                  .toDate()),
                                          id: currentMenuID,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Expanded(
                                      child: ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: currentMenu.length,
                                        padding: const EdgeInsets.all(0),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            ChowCard(
                                          isEmployee: true,
                                          fruit: currentMenu[index]['fruit'],
                                          mainCourse: currentMenu[index]
                                              ['main_course'],
                                          salad: currentMenu[index]['salad'],
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => EditPage(
                                                  id: currentMenuID,
                                                  fruit: currentMenu[index]
                                                      ['fruit'],
                                                  mainCourse: currentMenu[index]
                                                      ['main_course'],
                                                  salad: currentMenu[index]
                                                      ['salad'],
                                                ),
                                              ),
                                            );
                                          },
                                          index: index,
                                          date: DateFormat('dd/MM/yyyy').format(
                                              (currentMenu[index]['date']
                                                      as Timestamp)
                                                  .toDate()),
                                          students: (currentMenu[index]
                                                  ['students'] as List<dynamic>)
                                              .length
                                              .toString(),
                                          id: currentMenuID,
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  return const Text('Menu não encontrado.');
                                }
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
