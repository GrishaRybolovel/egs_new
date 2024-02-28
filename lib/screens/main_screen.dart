// import 'package:egs/ui/const.dart';
// // import 'package:egs/responsive.dart';
// import 'package:egs/screens/header.dart';
// import 'package:egs/screens/login/login.dart';
// import 'package:egs/screens/registration/register.dart';
// import 'package:egs/screens/side_menu.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MainScreen extends StatelessWidget {
//   const MainScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     bool isLoginScreen = false;
//     bool isRegisterScreen = false;
//     if (ModalRoute.of(context)!.settings.name == '/login') {
//       isLoginScreen = true;
//     } else if (ModalRoute.of(context)!.settings.name == '/register') {
//       isRegisterScreen = true;
//     }

//     return Scaffold(
//       drawer: const SideMenu(),
//       body: SafeArea(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // We want this side menu only for large screen
//             if (Responsive.isDesktop(context) &&
//                 !(isLoginScreen || isRegisterScreen))
//               const Expanded(
//                 // default flex = 1
//                 // and it takes 1/6 part of the screen
//                 child: SideMenu(),
//               ),
//             if (!(isLoginScreen || isRegisterScreen))
//               Expanded(
//                 // It takes 5/6 part of the screen
//                 flex: 5,
//                 child: Consumer<MenuAppController>(
//                   builder: (context, MenuAppController, child) {
//                     return Scaffold(
//                       body: SingleChildScrollView(
//                         primary: false,
//                         padding: const EdgeInsets.all(defaultPadding),
//                         child: Column(
//                           children: [
//                             const Header(),
//                             const SizedBox(height: defaultPadding),
//                             MenuAppController.currentScreen,
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
