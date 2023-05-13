import 'package:chow_time_ifsp/shared/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenusRepository extends ChangeNotifier {
  UserModel? _user;
  QuerySnapshot? _allMenus;
  QueryDocumentSnapshot? _currentMenu;

  UserModel? get user => _user;
  QuerySnapshot? allMenus() => _allMenus;
  QueryDocumentSnapshot? currentMenu() => _currentMenu;

  setUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  setAllMenus(QuerySnapshot newMenus) {
    _allMenus = newMenus;
    notifyListeners();
  }

  setCurrentMenu(QueryDocumentSnapshot newMenu) {
    _currentMenu = newMenu;
    notifyListeners();
  }
}
