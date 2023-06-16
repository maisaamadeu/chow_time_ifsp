//Importa as bibliotecas necessárias
import 'dart:io';
import 'package:chow_time_ifsp/firebase_options.dart';
import 'package:chow_time_ifsp/shared/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Esta é a classe que será responsável por maioria das funções no aplicativo
class FirebaseServices {
  UserModel? user; // Objeto UserModel que representa o usuário logado
  QuerySnapshot? allMenus; // Snapshot contendo todos os menus
  QueryDocumentSnapshot? currentMenu; // Snapshot do menu atual

  //Inicializa o Firebase
  Future<void> initFirebase() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      debugPrint('Erro ao inicializar o Firebase: $e');
    }
  }

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  //Obtém uma lista de pessoas do tipo escolhido, podendo ser tanto estudantes quanto servidores
  Future<List<QueryDocumentSnapshot>?> getPeople({required String type}) async {
    try {
      if (Firebase.apps.isEmpty) {
        await initFirebase();
      }

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(type).get();

      if (querySnapshot.docs.isNotEmpty) {
        List<QueryDocumentSnapshot> docs = querySnapshot.docs;
        return docs;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  //Realiza o login do usuário
  Future<bool> login(
      {required String userType,
      required String registration,
      String? password}) async {
    try {
      late QuerySnapshot querySnapshot;
      if (Firebase.apps.isEmpty) {
        await initFirebase();
      }

      if (userType == 'admin') {
        querySnapshot = await FirebaseFirestore.instance
            .collection('${userType}s')
            .where('registration', isEqualTo: registration)
            .where('password', isEqualTo: password)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('${userType}s')
            .where('registration', isEqualTo: registration)
            .get();
      }

      if (querySnapshot.docs.isNotEmpty) {
        user = UserModel(
          registration: (querySnapshot.docs[0].data() as Map)['registration'],
          userType: userType,
        );

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Erro ao fazer login: $e');
      return false;
    }
  }

  //Obtém os menus
  Future<bool> getMenu({DateTime? customDate}) async {
    try {
      if (Firebase.apps.isEmpty) {
        await initFirebase();
      }

      DateTime currentDate = customDate ?? DateTime.now();
      int weekDate = currentDate.weekday;

      DateTime startWeekTime =
          currentDate.subtract(Duration(days: weekDate - 1));
      DateTime endWeekTime = startWeekTime.add(const Duration(days: 4));

      String formattedStartWeekTime =
          DateFormat('dd/MM/yyyy').format(startWeekTime);
      String formattedEndWeekTime =
          DateFormat('dd/MM/yyyy').format(endWeekTime);

      allMenus = await FirebaseFirestore.instance.collection('menus').get();

      if (allMenus != null) {
        if (weekDate > 5) {
          startWeekTime = startWeekTime.add(const Duration(days: 7));
          endWeekTime = endWeekTime.add(const Duration(days: 7));
          formattedStartWeekTime =
              DateFormat('dd/MM/yyyy').format(startWeekTime);
          formattedEndWeekTime = DateFormat('dd/MM/yyyy').format(endWeekTime);
          weekDate = 1;
        }

        for (var menu in allMenus!.docs) {
          String formattedStartOfTheWeekInMenu = DateFormat('dd/MM/yyyy')
              .format(((menu.data() as Map)['start_of_the_week'] as Timestamp)
                  .toDate());
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
    } catch (e) {
      debugPrint('Erro ao obter o menu: $e');
      return false;
    }
  }

  //Edita o menu atual
  Future<void> editMenu({
    String? mainCourse,
    String? salad,
    String? fruit,
    required String documentID,
    required int index,
  }) async {
    try {
      if (Firebase.apps.isEmpty) {
        await initFirebase();
      }

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
      }
    } catch (e) {
      debugPrint('Erro ao editar o menu: $e');
    }
  }

  //Adiciona ou remove um estudante de um dia da semana
  Future<void> addOrRemoveStudent({
    required int index,
    required String registration,
    required String documentID,
    required VoidCallback callback,
  }) async {
    try {
      if (Firebase.apps.isEmpty) {
        await initFirebase();
      }

      var studentsRef =
          FirebaseFirestore.instance.collection('menus').doc(documentID);

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
      debugPrint('Erro na transação: $e');
    }
  }

  //Adiciona uma semana com base na última disponível
  Future<void> addWeek() async {
    try {
      if (Firebase.apps.isEmpty) {
        await initFirebase();
      }

      CollectionReference allMenus =
          FirebaseFirestore.instance.collection('menus');
      QuerySnapshot lastDates = await FirebaseFirestore.instance
          .collection('menus')
          .orderBy('start_of_the_week', descending: true)
          .limit(1)
          .get();

      List<QueryDocumentSnapshot> documents = lastDates.docs;

      List<DateTime> datesList = [];
      late DateTime startOfTheWeek;
      late DateTime endOfTheWeek;

      if (documents.isNotEmpty) {
        startOfTheWeek =
            (documents.first['start_of_the_week'] as Timestamp).toDate();
        endOfTheWeek =
            (documents.last['end_of_the_week'] as Timestamp).toDate();
      } else {
        DateTime currentDate = DateTime.now();
        int weekDate = currentDate.weekday;

        startOfTheWeek = currentDate.subtract(Duration(days: weekDate - 1));
        endOfTheWeek = startOfTheWeek.add(const Duration(days: 4));
      }

      DateTime newStartOfTheWeek = startOfTheWeek.add(const Duration(days: 7));
      DateTime newEndOfTheWeek = endOfTheWeek.add(const Duration(days: 7));

      while (newStartOfTheWeek.isBefore(newEndOfTheWeek) ||
          newStartOfTheWeek.isAtSameMomentAs(newEndOfTheWeek)) {
        datesList.add(newStartOfTheWeek);
        newStartOfTheWeek = newStartOfTheWeek.add(const Duration(days: 1));
      }

      final newWeek = {
        'start_of_the_week':
            newStartOfTheWeek.subtract(const Duration(days: 5)),
        'end_of_the_week': newEndOfTheWeek,
        'menu_days': [
          {
            'salad': null,
            'fruit': null,
            'main_course': null,
            'students': [],
            'date': Timestamp.fromDate(
              datesList[0].add(
                const Duration(
                  hours: 8,
                  minutes: 30,
                ),
              ),
            ),
          },
          {
            'salad': null,
            'fruit': null,
            'main_course': null,
            'students': [],
            'date': Timestamp.fromDate(
              datesList[1].add(
                const Duration(
                  hours: 8,
                  minutes: 30,
                ),
              ),
            ),
          },
          {
            'salad': null,
            'fruit': null,
            'main_course': null,
            'students': [],
            'date': Timestamp.fromDate(
              datesList[2].add(
                const Duration(
                  hours: 8,
                  minutes: 30,
                ),
              ),
            ),
          },
          {
            'salad': null,
            'fruit': null,
            'main_course': null,
            'students': [],
            'date': Timestamp.fromDate(
              datesList[3].add(
                const Duration(
                  hours: 8,
                  minutes: 30,
                ),
              ),
            ),
          },
          {
            'salad': null,
            'fruit': null,
            'main_course': null,
            'students': [],
            'date': Timestamp.fromDate(
              datesList[4].add(
                const Duration(
                  hours: 8,
                  minutes: 30,
                ),
              ),
            ),
          }
        ]
      };

      await allMenus.add(newWeek);
    } catch (e) {
      debugPrint('Erro ao adicionar a semana: $e');
    }
  }

  //Deleta os menus selecionados
  Future<void> deleteMenuItems(
      List<DocumentSnapshot<Object?>> deleteMenus) async {
    try {
      if (Firebase.apps.isEmpty) {
        await initFirebase();
      }

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (DocumentSnapshot<Object?> document in deleteMenus) {
        batch.delete(document.reference);
      }

      await batch.commit();
    } catch (error) {
      debugPrint('Erro ao excluir documentos: $error');
    }
  }

  //Deleta todos os documentos de uma coleção do firestore, podendo ser usuado para várias finalidades
  Future<void> deleteAllDocumentsInCollection(
      String collectionName, BuildContext context) async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection(collectionName);

      QuerySnapshot querySnapshot = await collectionReference.get();

      querySnapshot.docs.forEach((document) async {
        await document.reference.delete();
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content:
                const Text('Ocorreu um erro durante a exclusão dessas pessoas'),
            actions: <Widget>[
              TextButton(
                child: const Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  //Importa CSV de estudantes ou de servidores para o Firestore
  Future<void> importCSVToFirestore(
      String collectionName, BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String csvData = await file.readAsString();

        List<List<dynamic>> csvTable =
            const CsvToListConverter().convert(csvData);

        csvTable.removeAt(0);

        CollectionReference collectionReference =
            FirebaseFirestore.instance.collection(collectionName);

        for (var row in csvTable) {
          Map<String, dynamic> data = {
            'registration': row[0],
          };

          await collectionReference.add(data);
        }
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: Text('Ocorreu um erro durante a importação do CSV: $e'),
            actions: <Widget>[
              TextButton(
                child: const Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
