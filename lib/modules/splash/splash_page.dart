import 'package:chow_time_ifsp/modules/login/login_page.dart';
import 'package:chow_time_ifsp/shared/services/firebase_services.dart';
import 'package:chow_time_ifsp/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isError = false;

  Future<void> checkNetworkAndNavigate() async {
    bool isConnected = await FirebaseServices().isInternalIPAddress();

    await Future.delayed(Duration(seconds: 2));

    if (isConnected) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      setState(() {
        isError = true;
      });
    }
  }

  @override
  void initState() {
    checkNetworkAndNavigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(
                image: AssetImage('assets/images/ifsp.png'),
                height: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              isError
                  ? SizedBox(
                      width: 300,
                      child: Text(
                        "Você não está conectado a Internet ou não está conectado a rede interna do IFSP BTV",
                        style: GoogleFonts.lexendDeca(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.delete,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
