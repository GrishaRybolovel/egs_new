import 'package:egs/api/service.dart';
import 'package:egs/const.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/responsive.dart';
import 'package:egs/screens/dashboard/dashboard_screen.dart';
import 'package:egs/screens/registration/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _login() async {
    final response = await apiService.login(
      emailController.text,
      passwordController.text,
    );
    print(response);

    if (response?.containsKey('token') == true) {
      // Login successful, navigate to the Dashboard screen
      Provider.of<MenuAppController>(context, listen: false)
          .navigateTo(DashboardScreen());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка входа. Проверьте почту и пароль'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Логин'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: !Responsive.isDesktop(context)
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.center,
            children: [
              Container(
                width: !Responsive.isDesktop(context) ? 200 : 400,
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: EMAIL),
                ),
              ),
              Container(
                  width: !Responsive.isDesktop(context) ? 200 : 400,
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: PASSWORD),
                    obscureText: true,
                  )),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login,
                child: Text(LOGIN),
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Provider.of<MenuAppController>(context, listen: false)
                      .navigateTo(RegistrationScreen());
                },
                child: Text(DONT_HAVE_AN_ACCOUNT),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
