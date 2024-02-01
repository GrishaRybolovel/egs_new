import 'package:egs/controllers/MenuAppController.dart';
import 'package:egs/screens/dashboard/dashboard_screen.dart';
import 'package:egs/screens/projects/projects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
              context.read<MenuAppController>().closeMenu();
              Provider.of<MenuAppController>(context, listen: false)
                  .navigateTo(DashboardScreen());
            },
          ),
          DrawerListTile(
            title: "Объекты",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              context.read<MenuAppController>().closeMenu();
              Provider.of<MenuAppController>(context, listen: false)
                  .navigateTo(ProjectsScreen());
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
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
