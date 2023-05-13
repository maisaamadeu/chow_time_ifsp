import 'package:chow_time_ifsp/shared/services/firebase_services.dart';
import 'package:chow_time_ifsp/shared/themes/app_images.dart';
import 'package:chow_time_ifsp/shared/themes/app_text_styles.dart';
import 'package:chow_time_ifsp/shared/widgets/chow_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeStudents extends StatelessWidget {
  const HomeStudents({super.key, required this.firebaseServices});
  final FirebaseServices firebaseServices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
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

            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seja bem-vindo(a) ${firebaseServices.user!.firstName} ${firebaseServices.user!.lastName}!',
                      style: AppTextStyles.titleHome,
                    ),
                    Text(
                      'Selecione abaixo se irá comer ou não!',
                      style: AppTextStyles.trailingRegular,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ChowCard(
                        isEmployee: false,
                        fruit: 'Maça',
                        mainCourse: 'Macarrão',
                        salad: 'Rucúla',
                        onPressed: () {
                          print('Estou funcionando');
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => firebaseServices.getMenu(),
                      child: Text('Clica em mim'),
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
