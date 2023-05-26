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
  bool isError = false;
  FirebaseServices firebaseServices = FirebaseServices();

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
                      'Insira os dados abaixo para realizar o login',
                      style: AppTextStyles.titleRegular,
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
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: 'student',
                            groupValue: _userType,
                            onChanged: (value) => setState(
                              () {
                                _userType = value!;
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
                          setState(() {
                            isError = false;
                          });
                          bool response = await firebaseServices.login(
                              userType: _userType,
                              registration: controller.text);

                          if (response && context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  firebaseServices: firebaseServices,
                                ),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Ops!'),
                                content: const Text(
                                  "Ocorreu um problema ao tentar realizar o login, pedimos perdão pelo o incoveniente. Por favor, tente novamente!",
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
    );
  }
}
