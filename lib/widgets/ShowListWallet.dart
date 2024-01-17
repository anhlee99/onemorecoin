
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onemorecoin/model/TransactionModel.dart';
import 'package:onemorecoin/model/WalletModel.dart';
import '../pages/Transaction/addtransaction/AddNewGroupPage.dart';
import '../pages/Transaction/addtransaction/AddNotePage.dart';
import '../pages/Transaction/addtransaction/AddNotificationPage.dart';
import '../pages/Transaction/addtransaction/AddTransaction.dart';
import '../pages/Transaction/addtransaction/AddWalletPage.dart';
import '../pages/Transaction/addtransaction/DateSelectPage.dart';
import '../pages/Transaction/addtransaction/ListCurrencyPage.dart';
import '../pages/Transaction/addtransaction/ListGroupPage.dart';
import '../pages/Transaction/addtransaction/ListIconPage.dart';
import '../pages/Transaction/addtransaction/ListWalletPage.dart';

Future<T?> ShowListWalletPage<T>(
    BuildContext context,{
      required WalletModel wallet,
    }) async {
  return showCupertinoModalBottomSheet(
      context: context,
      enableDrag: true,
      builder: (context) =>
      Navigator(
        observers: [HeroControllerChild()],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MaterialWithModalsPageRoute(
                builder: (context) => ListWalletPage(
                  showWalletGlobal: true,
                  wallet: wallet,
                ),
                settings: settings,
              );
            case '/AddWalletPage':
              return MaterialWithModalsPageRoute(
                builder: (context) => const AddWalletPage(),
                settings: settings,
              );
            case '/ListCurrencyPage':
              return MaterialWithModalsPageRoute(
                builder: (context) => const ListCurrencyPage(),
                settings: settings,
              );
            case '/ListIconPage':
              return MaterialWithModalsPageRoute(
                builder: (context) => const ListIconPage(),
                settings: settings,
              );
          }
          return MaterialPageRoute(
            builder: (context) => const Placeholder(),
            settings: settings,
          );
        },
      )
  );

}


class HeroControllerChild extends HeroController {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}