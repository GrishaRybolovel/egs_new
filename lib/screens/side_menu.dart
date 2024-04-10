import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Theme.of(context).brightness == Brightness.dark
                ? Image.asset("assets/images/logo_white.png")
                : Image.asset("assets/logo.png"),
          ),
          DrawerListTile(
            title: "Сводка",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/dashboard");
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
    super.key,
    required this.title,
    required this.svgSrc,
    required this.press,
  });

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        // ignore: deprecated_member_use
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        colorFilter: ColorFilter.mode(
          Theme.of(context).iconTheme.color!,
          BlendMode.srcIn,
        ),
        height: 16,
      ),
      title: Text(
        title,
      ),
    );
  }
}
