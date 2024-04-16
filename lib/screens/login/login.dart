import 'package:egs/api/service.dart';
import 'package:egs/screens/header.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController();
  final TextEditingController passwordController =
      TextEditingController();
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
        actions: [
          ThemeSwitch(alreadyLoggedIn: false),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Row(
        children: [
          const Spacer(
            flex: 3,
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                const Spacer(flex: 5),
                Expanded(
                  flex: 9,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 3.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: TextField(
                                textAlign: TextAlign.start,
                                textAlignVertical: TextAlignVertical.center,
                                controller: emailController,
                                decoration: const InputDecoration(
                                  labelText: email,
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  prefixIcon: Icon(Icons.mail_outline),
                                  hintText: 'Электронная почта',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: TextField(
                                  textAlign: TextAlign.start,
                                  textAlignVertical: TextAlignVertical.center,
                                  controller: passwordController,
                                  decoration: const InputDecoration(
                                    labelText: password,
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    prefixIcon: Icon(Icons.lock_outline),
                                    hintText: 'Пароль',
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: ElevatedButton(
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
                                        content: Text(
                                            'Ошибка входа. Проверьте почту и пароль'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(login),
                              ),
                            ),
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
                  ),
                ),
                const Spacer(
                  flex: 5,
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 3,
          ),
        ],
      ),
    );
  }
}
