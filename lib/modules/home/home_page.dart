import 'package:chow_time_ifsp/modules/delete%20menus/delete_menus_page.dart';
import 'package:chow_time_ifsp/modules/edit%20menu/edit_menu_page.dart';
import 'package:chow_time_ifsp/modules/login/login_page.dart';
import 'package:chow_time_ifsp/shared/services/firebase_services.dart';
import 'package:chow_time_ifsp/shared/themes/app_images.dart';
import 'package:chow_time_ifsp/shared/themes/app_text_styles.dart';
import 'package:chow_time_ifsp/shared/widgets/chow_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.firebaseServices, this.customDate});

  final FirebaseServices firebaseServices;
  final DateTime? customDate;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isReloading = false;
  late DateTime dateSelected;

  @override
  void initState() {
    dateSelected = widget.customDate ?? DateTime.now();
    super.initState();
  }

  bool checkDateExists(bool add) {
    if (widget.firebaseServices.allMenus != null) {
      DateTime customDateTest = dateSelected;
      customDateTest = add
          ? customDateTest.add(const Duration(days: 7))
          : customDateTest.subtract(const Duration(days: 7));
      int weekDateTest = customDateTest.weekday;

      DateTime startWeekTimeTest =
          customDateTest.subtract(Duration(days: weekDateTest - 1));
      DateTime endWeekTimeTest = startWeekTimeTest.add(const Duration(days: 4));

      String formattedStartWeekTime =
          DateFormat('dd/MM/yyyy').format(startWeekTimeTest);
      String formattedEndWeekTime =
          DateFormat('dd/MM/yyyy').format(endWeekTimeTest);

      if (weekDateTest > 5) {
        startWeekTimeTest = startWeekTimeTest.add(const Duration(days: 7));
        endWeekTimeTest = endWeekTimeTest.add(const Duration(days: 7));
        formattedStartWeekTime =
            DateFormat('dd/MM/yyyy').format(startWeekTimeTest);
        formattedEndWeekTime = DateFormat('dd/MM/yyyy').format(endWeekTimeTest);
        weekDateTest = 1;
      }

      for (QueryDocumentSnapshot menu
          in widget.firebaseServices.allMenus!.docs) {
        String formattedStartOfTheWeekInMenu = DateFormat('dd/MM/yyyy').format(
            ((menu.data() as Map)['start_of_the_week'] as Timestamp).toDate());
        String formatedEndOfTheWeekInMenu = DateFormat('dd/MM/yyyy').format(
            ((menu.data() as Map)['end_of_the_week'] as Timestamp).toDate());

        if (formattedStartOfTheWeekInMenu == formattedStartWeekTime &&
            formatedEndOfTheWeekInMenu == formattedEndWeekTime) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            itemBuilder: widget.firebaseServices.user!.userType == 'employee'
                ? (context) => [
                      const PopupMenuItem<String>(
                        value: 'add',
                        child: Text('Adicionar Semana'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Apagar Semana'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Sair'),
                      ),
                    ]
                : (context) => [
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Sair'),
                      ),
                    ],
            onSelected: (value) {
              switch (value) {
                case 'add':
                  FirebaseServices().addWeek();
                  setState(() {});
                  setState(() {});
                  break;
                case 'delete':
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DeleteMenusPage(
                      firebaseServices: widget.firebaseServices,
                    ),
                  ));
                  break;
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
                  width: MediaQuery.of(context).size.width,
                ),
              ),

              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seja bem-vindo(a) ${widget.firebaseServices.user!.registration}!',
                            style: AppTextStyles.titleHome,
                          ),
                          Text(
                            widget.firebaseServices.user!.userType == 'student'
                                ? 'Selecione abaixo se irá comer ou não!'
                                : 'Selecione abaixo qual dia gostaria de editar!',
                            style: AppTextStyles.trailingRegular,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FutureBuilder<bool>(
                            future: widget.firebaseServices
                                .getMenu(customDate: dateSelected),
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
                                    String startOfTheWeekFormatted =
                                        DateFormat('dd/MM/yyyy').format(
                                            ((widget.firebaseServices
                                                            .currentMenu!
                                                            .data() as Map)[
                                                        'start_of_the_week']
                                                    as Timestamp)
                                                .toDate());
                                    String endOfTheWeekFormatted =
                                        DateFormat('dd/MM/yyyy').format(
                                            ((widget.firebaseServices
                                                            .currentMenu!
                                                            .data() as Map)[
                                                        'end_of_the_week']
                                                    as Timestamp)
                                                .toDate());

                                    return isReloading
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    widget.firebaseServices.user!
                                                                .userType ==
                                                            'employee'
                                                        ? IconButton(
                                                            onPressed: () {
                                                              bool result =
                                                                  checkDateExists(
                                                                      false);

                                                              if (result) {
                                                                setState(() {
                                                                  dateSelected =
                                                                      dateSelected
                                                                          .subtract(
                                                                              const Duration(days: 7));
                                                                });
                                                              }
                                                            },
                                                            icon: const Icon(Icons
                                                                .arrow_back_ios_outlined),
                                                          )
                                                        : Container(),
                                                    Text(
                                                      '$startOfTheWeekFormatted - $endOfTheWeekFormatted',
                                                      style: AppTextStyles
                                                          .trailingRegular,
                                                    ),
                                                    widget.firebaseServices.user!
                                                                .userType ==
                                                            'employee'
                                                        ? IconButton(
                                                            onPressed: () {
                                                              bool result =
                                                                  checkDateExists(
                                                                      true);

                                                              if (result) {
                                                                setState(() {
                                                                  dateSelected =
                                                                      dateSelected.add(
                                                                          const Duration(
                                                                              days: 7));
                                                                });
                                                              }
                                                            },
                                                            icon: const Icon(Icons
                                                                .arrow_forward_ios_outlined),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          currentMenu.length,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ChowCard(
                                                          lastIndex:
                                                              index + 1 ==
                                                                  currentMenu
                                                                      .length,
                                                          isEmployee: widget
                                                                      .firebaseServices
                                                                      .user!
                                                                      .userType ==
                                                                  'student'
                                                              ? false
                                                              : true,
                                                          fruit:
                                                              currentMenu[index]
                                                                  ['fruit'],
                                                          mainCourse:
                                                              currentMenu[index]
                                                                  [
                                                                  'main_course'],
                                                          salad:
                                                              currentMenu[index]
                                                                  ['salad'],
                                                          onPressed: widget
                                                                      .firebaseServices
                                                                      .user!
                                                                      .userType ==
                                                                  'student'
                                                              ? () async {
                                                                  await FirebaseServices()
                                                                      .addOrRemoveStudent(
                                                                          index:
                                                                              index,
                                                                          registration: widget
                                                                              .firebaseServices
                                                                              .user!
                                                                              .registration,
                                                                          documentID:
                                                                              currentMenuID,
                                                                          callback:
                                                                              () {
                                                                            setState(() {
                                                                              isReloading = true;
                                                                            });
                                                                          });

                                                                  setState(() {
                                                                    isReloading =
                                                                        false;
                                                                  });
                                                                }
                                                              : () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              EditMenuPage(
                                                                        id: currentMenuID,
                                                                        fruit: currentMenu[index]
                                                                            [
                                                                            'fruit'],
                                                                        mainCourse:
                                                                            currentMenu[index]['main_course'],
                                                                        salad: currentMenu[index]
                                                                            [
                                                                            'salad'],
                                                                        index:
                                                                            index,
                                                                        firebaseServices:
                                                                            widget.firebaseServices,
                                                                        lastDateTime:
                                                                            dateSelected,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                          index: index,
                                                          date: DateFormat(
                                                                  'dd/MM/yyyy - HH:mm:ss')
                                                              .format((currentMenu[
                                                                              index]
                                                                          [
                                                                          'date']
                                                                      as Timestamp)
                                                                  .toDate()),
                                                          students: (currentMenu[
                                                                          index]
                                                                      [
                                                                      'students']
                                                                  as List<
                                                                      dynamic>)
                                                              .length
                                                              .toString(),
                                                          id: currentMenuID,
                                                          containsStudent: (currentMenu[
                                                                          index]
                                                                      [
                                                                      'students']
                                                                  as List<
                                                                      dynamic>)
                                                              .contains(widget
                                                                  .firebaseServices
                                                                  .user!
                                                                  .registration),
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                          );
                                  } else {
                                    return SizedBox(
                                      width: 350,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'O menu selecionado não foi encontrado, tente reiniciar o aplicativo e caso o erro persista por favor consultar a equipe técnica.',
                                            style:
                                                AppTextStyles.trailingRegular,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                          ),
                        ],
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
}
