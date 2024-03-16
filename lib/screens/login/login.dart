import 'package:egs/api/service.dart';
import 'package:egs/main.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/responsive.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController(text: "test@test.ru");
  final TextEditingController passwordController = TextEditingController(text: "test");
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Логин'),
        actions: [
          Switch(
            value: MyApp.of(context).themeMode == ThemeMode.light,
            onChanged: (value) {
              setState(() {});
              if (value) {
                MyApp.of(context).changeTheme(ThemeMode.light);
              } else {
                MyApp.of(context).changeTheme(ThemeMode.dark);
              }
            }
            
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: !Responsive.isDesktop(context)
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: !Responsive.isDesktop(context) ? 200 : 400,
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: email),
                ),
              ),
              SizedBox(
                width: !Responsive.isDesktop(context) ? 200 : 400,
                child: TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: password),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  final response = await apiService.login(
                    emailController.text,
                    passwordController.text,
                  );

                  if (!context.mounted) return;

                  if (response?.containsKey('token') == true) {
                    Navigator.pushNamed(context, '/dashboard');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ошибка входа. Проверьте почту и пароль'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: const Text(login),
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(dontHaveAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
