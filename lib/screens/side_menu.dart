import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/logo.png"),
          ),
          DrawerListTile(
            title: "Сводка",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/dashboard");
              // context.read<MenuAppController>().closeMenu();
              // Provider.of<MenuAppController>(context, listen: false)
              //     .navigateTo(const DashboardScreen());
            },
          ),
          DrawerListTile(
            title: "Сотрудники",
            svgSrc: "assets/icons/menu_human.svg",
            press: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/employees");
            },
          ),
          DrawerListTile(
            title: "Объекты",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/projects");
              // context.read<MenuAppController>().closeMenu();
              // Provider.of<MenuAppController>(context, listen: false)
              // .navigateTo(const ProjectsScreen());
            },
          ),
          DrawerListTile(
            title: "Документы",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/documents");
            },
          ),
          DrawerListTile(
            title: "Письма",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/mails");
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
