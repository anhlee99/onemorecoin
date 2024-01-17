
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onemorecoin/model/TransactionModel.dart';
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

Future<T?> ShowTransactionPage<T>(
    BuildContext context,{
      TransactionModel? transactionModel,
    }) async {

  return showCupertinoModalBottomSheet(
      context: context,
      enableDrag: true,
      builder: (context) =>  Navigator(
        observers: [HeroControllerChild()],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MaterialWithModalsPageRoute(
                builder: (context) => AddTransaction(
                  transactionModel: transactionModel,
                ),
                settings: settings,
              );
            case '/ListGroupPage':
              final args = settings.arguments as Map<String, String>;
              return MaterialWithModalsPageRoute(
                builder: (context) => ListGroupPage(
                  title: args['title'],
                ),
                settings: settings,
              );
            case '/AddNewGroupPage':
              return MaterialWithModalsPageRoute(
                builder: (context) => const AddNewGroupPage(),
                settings: settings,
              );
            case '/ListIconPage':
              return MaterialWithModalsPageRoute(
                builder: (context) => const ListIconPage(),
                settings: settings,
              );
            case '/AddNotePage':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialWithModalsPageRoute(
                builder: (context) => AddNotePage(
                  value: args['note'],
                  groupId: args['groupId'],
                  isSuggest: true,
                ),
                settings: settings,
              );
            case '/DateSelectPage':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialWithModalsPageRoute(
                builder: (context) => DateSelectPage(
                  selectDate: args['selectDate'],
                ),
                settings: settings,
              );
            case '/ListWalletPage':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialWithModalsPageRoute(
                builder: (context) => ListWalletPage(
                  wallet: args['wallet'],
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
            case '/AddNotificationPage':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialWithModalsPageRoute(
                builder: (context) => AddNotificationPage(
                  selectDate: args['selectDate'],
                  submitOnPressed: args['submitOnPressed'],
                  isNotification: args['isNotification'],
                ),
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