import 'package:chow_time_ifsp/app_widget.dart';
import 'package:chow_time_ifsp/shared/repositories/menus_repository.dart';
import 'package:chow_time_ifsp/shared/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  FirebaseServices().initFirebase();
  runApp(
    ChangeNotifierProvider(
      create: (context) => MenusRepository(),
      child: const AppWidget(),
    ),
  ); //epj5bfbrl
}
