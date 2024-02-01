import 'package:egs/const.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:egs/screens/main_screen.dart';
import 'package:egs/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize(
  //   debug: true, // Set to false in production
  // );
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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ЭГС',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: MainScreen(),
      )
    );
  }
}