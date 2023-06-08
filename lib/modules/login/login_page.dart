import 'package:chow_time_ifsp/modules/edit%20people/edit_people_page.dart';
import 'package:chow_time_ifsp/modules/home/home_page.dart';
import 'package:chow_time_ifsp/shared/services/firebase_services.dart';
import 'package:chow_time_ifsp/shared/themes/app_colors.dart';
import 'package:chow_time_ifsp/shared/themes/app_images.dart';
import 'package:chow_time_ifsp/shared/themes/app_text_styles.dart';
import 'package:chow_time_ifsp/shared/widgets/input_data.dart';
import 'package:chow_time_ifsp/shared/widgets/label_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _userType = 'student';
  TextEditingController controller = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  bool isError = false;
  bool isPasswordError = false;
  bool isAdmin = false;
  int count = 0;
  FirebaseServices firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
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
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/ifsp.png'),
                          height: 200,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Insira os dados abaixo para realizar o login',
                          style: AppTextStyles.titleRegular,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InputData(
                          controller: controller,
                          labelText: 'Prontuário',
                          hintText: 'Ex: BT000000',
                          errorText: 'Este campo não pode ficar vazio!',
                          isError: isError,
                        ),
                        isAdmin
                            ? const SizedBox(
                                height: 10,
                              )
                            : Container(),
                        isAdmin
                            ? InputData(
                                controller: passwordEditingController,
                                labelText: 'Senha',
                                hintText: 'Ex: 12345678',
                                errorText: 'Este campo não pode ficar vazio!',
                                isError: isPasswordError,
                              )
                            : Container(),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                value: 'student',
                                groupValue: _userType,
                                onChanged: (value) => setState(
                                  () {
                                    _userType = value!;
                                    if (count > 10) {
                                      isAdmin = false;
                                      count = 0;
                                    }
                                  },
                                ),
                                contentPadding: const EdgeInsets.all(0),
                                title: const Text('Estudante'),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                value: 'employee',
                                groupValue: _userType,
                                onChanged: (value) => setState(
                                  () {
                                    _userType = value!;
                                    count++;
                                    if (count == 5) {
                                      isAdmin = true;
                                    } else if (count > 5) {
                                      isAdmin = false;
                                      count = 0;
                                      isPasswordError = false;
                                    }
                                  },
                                ),
                                contentPadding: const EdgeInsets.all(0),
                                title: const Text('Trabalhador'),
                              ),
                            ),
                          ],
                        ),
                        LabelButton(
                          labelText: 'Entrar',
                          onPressed: () async {
                            if (controller.text.isNotEmpty) {
                              if (isAdmin) {
                                setState(() {
                                  if (passwordEditingController.text.isEmpty) {
                                    isPasswordError = true;
                                  } else {
                                    isPasswordError = false;
                                  }
                                });
                              }
                              setState(() {
                                isError = false;
                              });

                              if (isAdmin && isPasswordError) return;

                              bool response = await firebaseServices.login(
                                  userType: isAdmin ? 'admin' : _userType,
                                  registration: controller.text,
                                  password: isAdmin
                                      ? passwordEditingController.text
                                      : null);

                              if (response && context.mounted) {
                                if (isAdmin) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const EditPeoplePage(),
                                    ),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(
                                        firebaseServices: firebaseServices,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Ops!'),
                                    content: const Text(
                                      "Prontuário não encontrado, por favor verifique se digitou corretamente e tente novamente!",
                                      textAlign: TextAlign.justify,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(14),
                                          child: const Text(
                                            "Okay",
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              setState(() {
                                isError = true;
                              });

                              if (isAdmin) {
                                if (passwordEditingController.text.isEmpty) {
                                  setState(() {
                                    isPasswordError = true;
                                  });
                                } else {
                                  setState(() {
                                    isPasswordError = false;
                                  });
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
          ),
        ],
      ),
    );
  }
}
