import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onemorecoin/Objects/NavigationTransitionType.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/AddNewGroupPage.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/AddNotePage.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/AddNotificationPage.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/AddTransaction.dart';
import 'package:onemorecoin/pages/BudgetScreen.dart';
import 'package:onemorecoin/pages/Transaction.dart';
import 'package:onemorecoin/pages/HomeScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/AddWalletPage.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/DateSelectPage.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/ListCurrencyPage.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/ListGroupPage.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/ListIconPage.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/ListWalletPage.dart';
import 'package:onemorecoin/widgets/ShowTransaction.dart';

import '../pages/ProfileScreen.dart';
import '../widgets/ShowDialogFullScreen.dart';
import 'TabNavigator.dart';



class NavigationBottom2 extends StatefulWidget {
  const NavigationBottom2({super.key});

  @override
  State<NavigationBottom2> createState() => _NavigationExampleState();
}


class _NavigationExampleState extends State<NavigationBottom2> {

  int currentPageIndex = 0;
  late PageController _pageController;
  Key _refreshKey = UniqueKey();

  List<Color> colors = [
    Colors.grey[100]!,
    Colors.grey[100]!,
    Colors.grey[100]!,
    Colors.grey[100]!,
  ];

  late final List<Widget> _pages = <Widget>[
     HomeScreen(
         title: "HomeScreen",
         jumpToPage: _jumpToPage,
     ),
     const Transaction(),
     const BudgetScreen(title: "BudgetScreen"),
     TabNavigator(
        tabItem: 'ProfileScreen',
        navigatorKey: GlobalKey<NavigatorState>(),
      ),
// ProfileScreen()
  ];


  List<BottomObject> buttonBarItems = [
    BottomObject(Icons.home, Icons.home_outlined, "Tổng quan"),
    BottomObject(Icons.wallet, Icons.wallet_outlined, "Giao dịch"),
    BottomObject(Icons.class_, Icons.class_outlined, "Ngân sách"),
    BottomObject(Icons.person, Icons.person_outlined, "Tài khoản"),
  ];

  Widget bottomBarButton(Size size, BottomObject bottomObject, Function() onSelect, bool isSelect) => SizedBox.fromSize(
    size: size,
    child: InkWell(
      onTap: onSelect,
      // borderRadius: BorderRadius.circular(50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.fill,
            child: Icon(isSelect ? bottomObject.selectedIcon : bottomObject.icon,
                color: isSelect ? Theme.of(context).colorScheme.surface : null,
                size: 35),
          ), // <-- Icon
          FittedBox(
            child: Text(bottomObject.label, style: TextStyle(color: isSelect ? Theme.of(context).colorScheme.surface : null)), // <-- Text
          )
        ],
      ),
    ),
  );

  List<Widget> buildBottomBarItems (Size size) {
    List<Widget> list = [];
    for (final item in buttonBarItems) {
      if (buttonBarItems.indexOf(item) == 2) {
        list.add(SizedBox(width: MediaQuery.of(context).size.width * 0.15));
      }
      list.add(bottomBarButton(size, item, () => {
        _jumpToPage(buttonBarItems.indexOf(item))
      }, currentPageIndex == buttonBarItems.indexOf(item)));
    }
    return list;
  }

  _jumpToPage(int index) {
    setState(() {
      currentPageIndex = index;
      _pageController.jumpToPage(currentPageIndex);
    });
  }

  Widget bottomAppBar(size) => BottomAppBar(
    shape: const CircularNotchedRectangle(), //shape of notch
    notchMargin: 5, //notche margin between floating button and bottom appbar
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: buildBottomBarItems(size),
    )
  );


  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
    _pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleLocaleChanged() => setState((){
    _refreshKey = UniqueKey();
  });

  @override
  Widget build(BuildContext context) {
    var size = Size(MediaQuery.of(context).size.width * 0.15, MediaQuery.of(context).size.width * 0.15);
    return Scaffold(
          key: _refreshKey,
          backgroundColor: colors[currentPageIndex],
          floatingActionButton: SizedBox(
            width: size.width,
            height: size.height,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: const CircleBorder(),
              elevation: 0.0,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                ShowTransactionPage(context);
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
          bottomNavigationBar: bottomAppBar(size),
        );
  }


}

class BottomObject {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  BottomObject(this.icon, this.selectedIcon, this.label);
}



class HeroControllerChild extends HeroController {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}