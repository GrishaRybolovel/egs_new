import 'package:egs/api/service.dart';
import 'package:egs/const.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/responsive.dart';
import 'package:egs/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
      Provider.of<MenuAppController>(context, listen: false)
          .navigateTo(LoginScreen());
    } else {
      String message = '';
      if (emailController.text.isEmpty) {
        message = "Поле '$EMAIL' не должно быть пустым";
      } else if (passwordController.text.isEmpty) {
        message = "Поле '$PASSWORD' не должно быть пустым";
      } else if (nameController.text.isEmpty) {
        message = "Поле '$NAME' не должно быть пустым";
      } else if (surnameController.text.isEmpty) {
        message = "Поле '$SURNAME' не должно быть пустым";
      } else if (lastnameController.text.isEmpty) {
        message = "Поле '$LAST_NAME' не должно быть пустым";
      } else if (response?.statusCode == 500) {
        message = 'Пользователь с такой почтой уже существует';
      } else {
        message = 'Ошибка, попробуйте еще раз :(';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 3),
        ),
      );
      // Registration failed, show an error message or handle accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
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
                  ),
                ),
                Container(
                  width: !Responsive.isDesktop(context) ? 200 : 400,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: NAME),
                  ),
                ),
                Container(
                  width: !Responsive.isDesktop(context) ? 200 : 400,
                  child: TextFormField(
                    controller: surnameController,
                    decoration: InputDecoration(labelText: SURNAME),
                  ),
                ),
                Container(
                  width: !Responsive.isDesktop(context) ? 200 : 400,
                  child: TextFormField(
                    controller: lastnameController,
                    decoration: InputDecoration(labelText: LAST_NAME),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _register,
                  child: Text(REGISTER),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<MenuAppController>(context, listen: false)
                        .navigateTo(LoginScreen());
                  },
                  child: Text(ALREADY_HAVE_AN_ACCOUNT),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
