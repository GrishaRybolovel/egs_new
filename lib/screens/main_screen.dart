import 'package:egs/const.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/responsive.dart';
import 'package:egs/screens/header.dart';
import 'package:egs/screens/login/login.dart';
import 'package:egs/screens/registration/register.dart';
import 'package:egs/screens/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentScreen = context.watch<MenuAppController>().currentScreen;

    final isLoginScreen = (currentScreen is LoginScreen);
    final isRegisterScreen = (currentScreen is RegistrationScreen);

    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoginScreen || isRegisterScreen)
              Expanded(
                // It takes 5/6 part of the screen
                child: Consumer<MenuAppController>(
                  builder: (context, MenuAppController, child) {
                    return MenuAppController.currentScreen;
                  },
                ),
              ),
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context) &&
                !(isLoginScreen || isRegisterScreen))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            if (!(isLoginScreen || isRegisterScreen))
              Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: Consumer<MenuAppController>(
                  builder: (context, MenuAppController, child) {
                    return Scaffold(
                      body: SingleChildScrollView(
                        primary: false,
                        padding: EdgeInsets.all(defaultPadding),
                        child: Column(children: [
                          Header(),
                          SizedBox(height: defaultPadding),
                          MenuAppController.currentScreen,
                        ]),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
