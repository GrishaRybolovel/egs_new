import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/routes.dart';
import 'package:egs/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => MenuAppController(),
      ),
    ],
    child: MyApp(),
  ),
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ЭГС',
      theme: themeData,
      initialRoute: '/login',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
