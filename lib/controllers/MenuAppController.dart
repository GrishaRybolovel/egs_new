import 'package:egs/api/project_api.dart';
import 'package:egs/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:egs/model/message.dart';
import 'package:egs/api/message_api.dart';

class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _currentScreen = LoginScreen();
  String search = '';
  List<Message> messages = [];

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  Widget get currentScreen => _currentScreen;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void changeSearch(String input) {
    search = input;
    notifyListeners();
  }

  void closeMenu() {
    _scaffoldKey.currentState!.closeDrawer();
  }

  void navigateTo(Widget screen) {
    _currentScreen = screen;
    search = '';
    notifyListeners();
  }

  // Future<List<Message>> getMessages(int projectId) async{
  //   List<Message> fetchedData = await MessageApi().fetchMessages();
  //   messages.clear();
  //
  //   for(Message element in fetchedData){
  //     if(element.task == projectId){
  //       messages.add(element);
  //     }
  //   }
  //
  //   notifyListeners();
  //
  //   return messages;
  // }
}
