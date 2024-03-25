import 'package:egs/api/service.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/main.dart';
import 'package:egs/responsive.dart';
import 'package:egs/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egs/api/service.dart';
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
    setState(() {
      try {
        userFuture = ApiService().fetchUserData();
      } catch (error) {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: userFuture,
        builder: (context, snapshot) {
          if (userFuture == null) {
            // messagesFuture is not yet initialized
            return AppBar(
              title: const Text('ЭГС'),
              actions: [
                IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu)),
                Expanded(child: SearchField()),
                const CircularProgressIndicator()
              ],
            );
          } else if (snapshot.hasError) {
            // Error while fetching data, show an error message
            return AppBar(
              title: const Text('ЭГС'),
              actions: [
                IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu)),
                Expanded(child: SearchField()),
                ProfileCard(
                  name: 'Undefined',
                  surname: 'Undefined',
                )
              ],
            );
          } else {
            String name = snapshot.data?.name ?? 'Undefined';
            String surname = snapshot.data?.surname ?? 'Undefined';
            return AppBar(
              title: const Text('ЭГС'),
              actions: [
                IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu)),
                Expanded(child: SearchField()),
                ThemeSwitch(alreadyLoggedIn: true),
                ProfileCard(
                  name: name,
                  surname: surname,
                )
              ],
            );
          }
        });
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
    required this.name,
    required this.surname,
  }) : super(key: key);

  final String name;
  final String surname;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        offset: const Offset(0, 60),
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
          margin: const EdgeInsets.only(left: defaultPadding),
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: Row(
            children: [
              const Icon(Icons.person),
              if (!Responsive.isMobile(context))
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                  child: Text("$name $surname"),
                ),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ));
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

class ThemeSwitch extends StatefulWidget {
  ThemeSwitch({super.key, this.alreadyLoggedIn});
  bool? alreadyLoggedIn = false;

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: MyApp.of(context).themeMode == ThemeMode.dark ? true : false,
      onChanged: (value) async {
          if (widget.alreadyLoggedIn!) {
            await sendChangeTheme(isDark: value);
            if (!context.mounted) return;
          }
          MyApp.of(context).changeTheme(value ? ThemeMode.dark : ThemeMode.light);
        setState(() {});
      },
    );
  }

  Future<void> sendChangeTheme({required bool isDark}) async {
    final User user = await ApiService().fetchUserData();
    int userId = user.id ?? 0;
    final newUser = user.copyWith(isDark: isDark);
    await ApiService().updateUser(userId, newUser);
  }
}
