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

    allMenus = await FirebaseFirestore.instance.collection('menus').get();

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
    var menuRef =
        FirebaseFirestore.instance.collection('menus').doc(documentID);

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

  Future<void> addOrRemoveStudent({
    required int index,
    required String registration,
    required String documentID,
    required VoidCallback callback,
  }) async {
    var studentsRef =
        FirebaseFirestore.instance.collection('menus').doc(documentID);

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

  Future<void> addWeek() async {
    CollectionReference allMenus =
        FirebaseFirestore.instance.collection('menus');
    QuerySnapshot lastDates = await FirebaseFirestore.instance
        .collection('menus')
        .orderBy('start_of_the_week', descending: true)
        .limit(1)
        .get();

    List<QueryDocumentSnapshot> documents = lastDates.docs;

    if (documents.isNotEmpty) {
      List<DateTime> datesList = [];

      DateTime startOfTheWeek =
          (documents.first['start_of_the_week'] as Timestamp).toDate();
      DateTime endOfTheWeek =
          (documents.last['end_of_the_week'] as Timestamp).toDate();

      DateTime newStartOfTheWeek = startOfTheWeek.add(Duration(days: 7));
      DateTime newEndOfTheWeek = endOfTheWeek.add(Duration(days: 7));

      while (newStartOfTheWeek.isBefore(newEndOfTheWeek) ||
          newStartOfTheWeek.isAtSameMomentAs(newEndOfTheWeek)) {
        datesList.add(newStartOfTheWeek);
        newStartOfTheWeek = newStartOfTheWeek.add(Duration(days: 1));
      }

      final newWeek = {
        'start_of_the_week': newStartOfTheWeek.subtract(Duration(days: 5)),
        'end_of_the_week': newEndOfTheWeek,
        'menu_days': [
          {
            'salad': null,
            'fruit': null,
            'main_course': null,
            'students': [],
            'date': Timestamp.fromDate(datesList[0]),
          },
          {
            'salad': null,
            'fruit': null,
            'main_course': null,
            'students': [],
            'date': Timestamp.fromDate(datesList[1]),
          },
          {
            'salad': null,
            'fruit': null,
            'main_course': null,
            'students': [],
            'date': Timestamp.fromDate(datesList[2]),
          },
          {
            'salad': null,
            'fruit': null,
            'main_course': null,
            'students': [],
            'date': Timestamp.fromDate(datesList[3]),
          },
          {
            'salad': null,
            'fruit': null,
            'main_course': null,
            'students': [],
            'date': Timestamp.fromDate(datesList[4]),
          }
        ]
      };

      allMenus.add(newWeek);
    }
  }

  Future<void> deleteMenuItems(
      List<DocumentSnapshot<Object?>> deleteMenus) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (DocumentSnapshot<Object?> document in deleteMenus) {
      batch.delete(document.reference);
    }

    try {
      await batch.commit();
    } catch (error) {
      debugPrint('Erro ao excluir documentos: $error');
    }
  }
}
