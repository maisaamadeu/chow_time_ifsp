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
        userType: userType,
      );

      return true;
    }

    return false;
  }

  Future<bool> getMenu() async {
    DateTime currentDate = DateTime.now();
    int weekDate = currentDate.weekday;

    DateTime startWeekTime = currentDate.subtract(Duration(days: weekDate - 1));
    DateTime endWeekTime = startWeekTime.add(const Duration(days: 4));

    String formattedStartWeekTime =
        DateFormat('dd/MM/yyyy').format(startWeekTime);
    String formattedEndWeekTime = DateFormat('dd/MM/yyyy').format(endWeekTime);

    allMenus = await FirebaseFirestore.instance.collection('menu').get();

    if (allMenus != null) {
      if (weekDate > 5) {
        startWeekTime =
            startWeekTime.add(const Duration(days: 7)); //Não está adicionando
        endWeekTime =
            endWeekTime.add(const Duration(days: 7)); //Não está adicionado
        formattedStartWeekTime = DateFormat('dd/MM/yyyy').format(startWeekTime);
        formattedEndWeekTime = DateFormat('dd/MM/yyyy').format(endWeekTime);
        weekDate = 1;
      }

      for (var menu in allMenus!.docs) {
        String formattedStartOfTheWeekInMenu = DateFormat('dd/MM/yyyy').format(
            ((menu.data() as Map)['start_of_the_week'] as Timestamp).toDate());
        String formatedEndOfTheWeekInMenu = DateFormat('dd/MM/yyyy').format(
            ((menu.data() as Map)['end_of_the_week'] as Timestamp).toDate());

        if (formattedStartOfTheWeekInMenu == formattedStartWeekTime &&
            formatedEndOfTheWeekInMenu == formattedEndWeekTime) {
          currentMenu = menu;

          return true;
        }
      }
    }
    return false;
  }

  Future<void> editMenu({
    String? mainCourse,
    String? salad,
    String? fruit,
    required String documentID,
    required int index,
  }) async {
    var menuRef = FirebaseFirestore.instance.collection('menu').doc(documentID);

    var snapshot = await menuRef.get();

    if (snapshot.exists) {
      var data = snapshot.data();
      var menuDays = data!['menu_days'];

      menuDays[index]['salad'] = salad;
      menuDays[index]['main_course'] = mainCourse;
      menuDays[index]['fruit'] = fruit;

      await menuRef.set(data);
    } else {}
  }
}

Future<void> addOrRemoveStudent({
  required int index,
  required String registration,
  required String documentID,
  required VoidCallback callback,
}) async {
  var studentsRef =
      FirebaseFirestore.instance.collection('menu').doc(documentID);

  try {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      var snapshot = await transaction.get(studentsRef);

      if (snapshot.exists) {
        var data = snapshot.data();
        List<dynamic> students = data!['menu_days'][index]['students'];

        if (students.contains(registration)) {
          students.remove(registration);
        } else {
          students.add(registration);
        }

        transaction.set(studentsRef, data);

        callback();
      }
    });
  } catch (e) {
    // Trate qualquer erro de transação aqui
    print('Erro na transação: $e');
  }
}


  // Future<void> addWeek() async {
  //   DocumentController().documentsStarted.sort((a, b) => b.compareTo(a));
  //   DocumentController().documentsEnd.sort((a, b) => b.compareTo(a));

  //   Timestamp startDay = Timestamp.fromDate(
  //       (DocumentController().documentsStarted[0] as DateTime)
  //           .add(const Duration(days: 7)));
  //   Timestamp endDay = Timestamp.fromDate(
  //       (DocumentController().documentsEnd[0] as DateTime)
  //           .add(const Duration(days: 7)));

  //   final menuRef = FirebaseFirestore.instance.collection('menu');

  //   final newWeek = {
  //     'end_of_the_week': endDay,
  //     'start_of_the_week': startDay,
  //     'menu_days': [
  //       {'salad': null, 'fruit': null, 'main_course': null, 'students': []},
  //       {'salad': null, 'fruit': null, 'main_course': null, 'students': []},
  //       {'salad': null, 'fruit': null, 'main_course': null, 'students': []},
  //       {'salad': null, 'fruit': null, 'main_course': null, 'students': []},
  //       {'salad': null, 'fruit': null, 'main_course': null, 'students': []}
  //     ]
  //   };

  //   await menuRef.add(newWeek);
  //   print('Deu certo!');
  // }


