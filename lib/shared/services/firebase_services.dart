import 'package:chow_time_ifsp/firebase_options.dart';
import 'package:chow_time_ifsp/shared/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirebaseServices {
  UserModel? user;
  QuerySnapshot? allMenus;
  QueryDocumentSnapshot? currentMenu;

  Future<void> initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<bool> login({
    required String userType,
    required String registration,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('${userType}s')
        .where('registration', isEqualTo: registration)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      user = UserModel(
        firstName: (querySnapshot.docs[0].data() as Map)['first_name'],
        lastName: (querySnapshot.docs[0].data() as Map)['last_name'],
        registration: (querySnapshot.docs[0].data() as Map)['registration'],
      );

      return true;
    }

    return false;
  }

  Future<void> getMenu() async {
    DateTime currentDate = DateTime.now();
    int weekDate = currentDate.weekday;

    DateTime startWeekTime = currentDate.subtract(Duration(days: weekDate - 1));
    DateTime endWeekTime = startWeekTime.add(const Duration(days: 5));

    String formattedStartWeekTime =
        DateFormat('dd/MM/yyyy').format(startWeekTime);
    String formattedEndWeekTime = DateFormat('dd/MM/yyyy').format(endWeekTime);

    allMenus = await FirebaseFirestore.instance.collection('menu').get();

    if (allMenus != null) {
      for (var menu in allMenus!.docs) {
        String formattedStartOfTheWeekInMenu = DateFormat('dd/MM/yyyy').format(
            ((menu.data() as Map)['start_of_the_week'] as Timestamp).toDate());
        String formatedEndOfTheWeekInMenu = DateFormat('dd/MM/yyyy').format(
            ((menu.data() as Map)['end_of_the_week'] as Timestamp).toDate());

        if (formattedStartOfTheWeekInMenu == formattedStartWeekTime &&
            formatedEndOfTheWeekInMenu == formattedEndWeekTime) {
          currentMenu = menu;
        }
      }
    }
  }
}
