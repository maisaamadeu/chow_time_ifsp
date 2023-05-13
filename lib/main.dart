import 'package:chow_time_ifsp/app_widget.dart';
import 'package:chow_time_ifsp/shared/services/firebase_services.dart';
import 'package:flutter/material.dart';

void main() async {
  FirebaseServices().initFirebase();
  runApp(const AppWidget());
}
