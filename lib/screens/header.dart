import 'package:egs/api/service.dart';
import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/responsive.dart';
import 'package:egs/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ui/const.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('ЭГС'),
      actions: [
        IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu)),
        Expanded(child: SearchField()),
        const ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

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
            // TODO change
            // context.read<MenuAppController>().closeMenu();
            ApiService().logout();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.only(left: defaultPadding),
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              const Icon(Icons.person),
              if (!Responsive.isMobile(context))
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                  child: Text("Test Test"),
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
        fillColor: secondaryColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: ElevatedButton(
          style: TextButton.styleFrom(
            minimumSize: const Size.square(defaultPadding),
          ),
          onPressed: () {
            String searchText =
                _controller.text; // Get the text from the controller
            Provider.of<MenuAppController>(context, listen: false)
                .changeSearch(searchText);
            print(
                Provider.of<MenuAppController>(context, listen: false).search);
          },
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}
