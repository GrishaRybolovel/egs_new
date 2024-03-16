import 'package:egs/api/service.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/model/user.dart';
import 'package:egs/routes.dart';
import 'package:egs/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

Future<void> initSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  sharedPreferences = prefs;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSharedPreferences();
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;
  ApiService apiService = ApiService();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (sharedPreferences.getString('token') != null) {
      getTheme().then((value) => {
            setState(() {
              themeMode = value ? ThemeMode.dark : ThemeMode.light;
            })
          });
    }
  }

  Future<bool> getTheme() async {
    User user = await apiService.fetchUserData();
    bool isDark = user.isDark ?? true;
    return isDark;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ЭГС',
      initialRoute: '/login',
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: themeMode,
    );
  }

  void changeTheme(ThemeMode newThemeMode) {
    setState(() {
      themeMode = newThemeMode;
    });
  }
}
