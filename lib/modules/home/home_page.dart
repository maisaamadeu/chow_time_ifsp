import 'package:chow_time_ifsp/modules/delete%20menus/delete_menus_page.dart';
import 'package:chow_time_ifsp/modules/edit/edit_page.dart';
import 'package:chow_time_ifsp/modules/login/login_page.dart';
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
  bool isReloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Container(
                          height: MediaQuery.sizeOf(context).width * 0.15,
                          margin: const EdgeInsetsDirectional.only(top: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                ),
                                icon: const Icon(Icons.exit_to_app),
                              ),
                              widget.firebaseServices.user!.userType ==
                                      'employee'
                                  ? TextButton(
                                      onPressed: () {
                                        FirebaseServices().addWeek();
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(Icons.add),
                                          Text('Adicionar ')
                                        ],
                                      ),
                                    )
                                  : Container(),
                              widget.firebaseServices.user!.userType ==
                                      'employee'
                                  ? TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DeleteMenusPage(),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.delete),
                                          Text('Remover')
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Text(
                          'Seja bem-vindo(a) ${widget.firebaseServices.user!.firstName} ${widget.firebaseServices.user!.lastName}!',
                          style: AppTextStyles.titleHome,
                        ),
                        Text(
                          'Selecione abaixo se irá comer ou não!',
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

                                  return isReloading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Expanded(
                                          child: ListView.builder(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            itemCount: currentMenu.length,
                                            padding: const EdgeInsets.all(0),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) =>
                                                ChowCard(
                                              isEmployee: widget
                                                          .firebaseServices
                                                          .user!
                                                          .userType ==
                                                      'student'
                                                  ? false
                                                  : true,
                                              fruit: currentMenu[index]
                                                  ['fruit'],
                                              mainCourse: currentMenu[index]
                                                  ['main_course'],
                                              salad: currentMenu[index]
                                                  ['salad'],
                                              onPressed: widget.firebaseServices
                                                          .user!.userType ==
                                                      'student'
                                                  ? () async {
                                                      await FirebaseServices()
                                                          .addOrRemoveStudent(
                                                              index: index,
                                                              registration: widget
                                                                  .firebaseServices
                                                                  .user!
                                                                  .registration,
                                                              documentID:
                                                                  currentMenuID,
                                                              callback: () {
                                                                print(
                                                                    'object0');
                                                                setState(() {
                                                                  isReloading =
                                                                      true;
                                                                });
                                                              });

                                                      setState(() {
                                                        // Atualização do segundo estado após 1 segundo
                                                        isReloading = false;
                                                      });
                                                    }
                                                  : () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditPage(
                                                            id: currentMenuID,
                                                            fruit: currentMenu[
                                                                index]['fruit'],
                                                            mainCourse:
                                                                currentMenu[
                                                                        index][
                                                                    'main_course'],
                                                            salad: currentMenu[
                                                                index]['salad'],
                                                            index: index,
                                                          ),
                                                        ),
                                                      );
                                                      setState(() {});
                                                    },
                                              index: index,
                                              date: DateFormat('dd/MM/yyyy')
                                                  .format((currentMenu[index]
                                                          ['date'] as Timestamp)
                                                      .toDate()),
                                              students: (currentMenu[index]
                                                          ['students']
                                                      as List<dynamic>)
                                                  .length
                                                  .toString(),
                                              id: currentMenuID,
                                              containsStudent:
                                                  (currentMenu[index]
                                                              ['students']
                                                          as List<dynamic>)
                                                      .contains(widget
                                                          .firebaseServices
                                                          .user!
                                                          .registration),
                                            ),
                                          ),
                                        );
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
