import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:egs/api/service.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/main.dart';
import 'package:egs/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egs/model/user.dart';

import '../ui/const.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late Future<User>? userFuture;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    setState(
      () {
        try {
          userFuture = ApiService().fetchUserData();
        } catch (error) {
          rethrow;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: userFuture,
      builder: (context, snapshot) {
        final bool login = snapshot.hasData;
        return AppBar(
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Icon(Icons.menu, size: 32),
                ),
              ),
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            Expanded(
              child: SearchField(),
            ),
            ThemeSwitch(alreadyLoggedIn: login),
            (userFuture == null)
                ? const CircularProgressIndicator()
                : ProfileCard(
                    name: login ? snapshot.data!.name : '',
                    surname: login ? snapshot.data!.surname : '',
                  ),
          ],
        );
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.surname,
  });

  final String name;
  final String surname;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return [
          const PopupMenuItem<String>(
            value: 'logout',
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: defaultPadding / 4),
              leading: Icon(Icons.exit_to_app),
              title: Text('Выйти'),
            ),
          ),
        ];
      },
      onSelected: (value) {
        if (value == 'logout') {
          ApiService().logout();
          Navigator.pushNamed(context, '/login');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Row(
                children: [
                  const Icon(Icons.person),
                  if (!Responsive.isMobile(context))
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2),
                      child: Text("$name $surname"),
                    ),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: "Поиск",
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(14),
          ),
          onPressed: () {
            String searchText =
                _controller.text; // Get the text from the controller
            Provider.of<MenuAppController>(context, listen: false)
                .changeSearch(searchText);
          },
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ThemeSwitch extends StatefulWidget {
  ThemeSwitch({super.key, this.alreadyLoggedIn});

  bool? alreadyLoggedIn = false;

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: AnimatedToggleSwitch<bool>.dual(
        current: MyApp.of(context).themeMode == ThemeMode.dark ? true : false,
        first: true,
        second: false,
        indicatorSize: const Size.fromWidth(40.0),
        animationDuration: const Duration(milliseconds: 600),
        style: ToggleStyle(
          borderColor: Colors.transparent,
          indicatorColor: Theme.of(context).colorScheme.background,
          backgroundColor: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10.0),
        ),
        customStyleBuilder: (context, local, global) {
          if (global.position <= 0.0) {
            return ToggleStyle(
                backgroundColor: Theme.of(context).colorScheme.primary);
          }
          return ToggleStyle(
            backgroundGradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary,
              ],
              stops: [
                global.position - (1 - 2 * max(0, global.position - 0.5)) * 0.7,
                global.position + max(0, 2 * (global.position - 0.5)) * 0.7,
              ],
            ),
          );
        },
        borderWidth: 6.0,
        loadingIconBuilder: (context, global) => CupertinoActivityIndicator(
          color: Color.lerp(
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary,
            global.position,
          ),
        ),
        onChanged: (value) async {
          if (widget.alreadyLoggedIn!) {
            await sendChangeTheme(isDark: value);
            if (!context.mounted) return;
          }
          MyApp.of(context)
              .changeTheme(value ? ThemeMode.dark : ThemeMode.light);
          setState(() {});
        },
        iconBuilder: (value) => value
            ? Icon(Icons.nightlight_round,
                color: Theme.of(context).colorScheme.primary, size: 32.0)
            : Icon(Icons.sunny,
                color: Theme.of(context).colorScheme.primary, size: 32.0),
        textBuilder: (value) => value
            ? Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Темная',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              )
            : Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Светлая',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> sendChangeTheme({required bool isDark}) async {
    final User user = await ApiService().fetchUserData();
    int userId = user.id ?? 0;
    final newUser = user.copyWith(isDark: isDark);
    await ApiService().updateUser(userId, newUser);
  }
}
