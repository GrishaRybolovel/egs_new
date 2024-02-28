import 'package:egs/api/service.dart';
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
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
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
                SizedBox(
                  width: !Responsive.isDesktop(context) ? 200 : 400,
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: name),
                  ),
                ),
                SizedBox(
                  width: !Responsive.isDesktop(context) ? 200 : 400,
                  child: TextFormField(
                    controller: surnameController,
                    decoration: const InputDecoration(labelText: surname),
                  ),
                ),
                SizedBox(
                  width: !Responsive.isDesktop(context) ? 200 : 400,
                  child: TextFormField(
                    controller: lastnameController,
                    decoration: const InputDecoration(labelText: lastName),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text(register),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(alreadyHaveAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
