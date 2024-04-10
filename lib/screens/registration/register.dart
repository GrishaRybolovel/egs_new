import 'package:egs/api/service.dart';
import 'package:egs/screens/header.dart';
import 'package:egs/ui/const.dart';
import 'package:egs/responsive.dart';
import 'package:egs/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final ApiService apiService = ApiService();

  void _register() async {
    final response = await apiService.register(
      emailController.text,
      passwordController.text,
      nameController.text,
      surnameController.text,
      lastnameController.text,
    );

    if (response?.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      String message = '';
      if (emailController.text.isEmpty) {
        message = "Поле '$email' не должно быть пустым";
      } else if (passwordController.text.isEmpty) {
        message = "Поле '$password' не должно быть пустым";
      } else if (nameController.text.isEmpty) {
        message = "Поле '$name' не должно быть пустым";
      } else if (surnameController.text.isEmpty) {
        message = "Поле '$surname' не должно быть пустым";
      } else if (lastnameController.text.isEmpty) {
        message = "Поле '$lastName' не должно быть пустым";
      } else if (response?.statusCode == 500) {
        message = 'Пользователь с такой почтой уже существует';
      } else {
        message = 'Ошибка, попробуйте еще раз :(';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
      // Registration failed, show an error message or handle accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
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
            flex: 6,
            child: Column(
              children: [
                const Spacer(flex: 3),
                Expanded(
                  flex: 15,
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
                                controller: nameController,
                                decoration: const InputDecoration(
                                  labelText: name,
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  prefixIcon: Icon(Icons.person),
                                  hintText: 'Имя',
                                ),
                              ),
                            ),
                            // такое же для фамилии
                            Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: TextField(
                                textAlign: TextAlign.start,
                                textAlignVertical: TextAlignVertical.center,
                                controller: surnameController,
                                decoration: const InputDecoration(
                                  labelText: surname,
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  prefixIcon: Icon(Icons.person),
                                  hintText: 'Фамилия',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: TextField(
                                textAlign: TextAlign.start,
                                textAlignVertical: TextAlignVertical.center,
                                controller: lastnameController,
                                decoration: const InputDecoration(
                                  labelText: lastName,
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  prefixIcon: Icon(Icons.person),
                                  hintText: 'Отчество',
                                ),
                              ),
                            ),
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
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: ElevatedButton(
                                onPressed: _register,
                                child: const Text(register),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: const Text(alreadyHaveAccount),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 3,
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
