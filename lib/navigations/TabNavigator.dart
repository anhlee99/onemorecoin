import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onemorecoin/pages/ProfileScreen.dart';

import '../pages/Profile/profile_support.dart';


class TabNavigator extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  const TabNavigator({super.key, required this.navigatorKey, required this.tabItem});

  @override
  Widget build(BuildContext context) {
    Widget? child;

    if(tabItem == 'ProfileScreen') {
      child = const ProfileScreen();
    }

    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialWithModalsPageRoute(
              builder: (context) => child ??  const Placeholder(),
              settings: settings,
            );
          case '/profile_support':
            return MaterialWithModalsPageRoute(
              builder: (context) => ProfileSupportPage(),
              settings: settings,
            );
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
      },
    );
  }
}
