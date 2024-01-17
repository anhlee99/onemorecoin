import 'package:flutter/material.dart';
import 'package:onemorecoin/pages/HomeScreen.dart';


class NavigationBottom extends StatefulWidget {
  const NavigationBottom({super.key});

  @override
  State<NavigationBottom> createState() => _NavigationExampleState();
}


class _NavigationExampleState extends State<NavigationBottom> {
  int currentPageIndex = 0;
  final List<Widget> _pages = <Widget>[
  ];
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        floatingActionButton: SizedBox(
          width: 70.0,
          height: 70.0,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            elevation: 0.0,
            child: const Icon(
              Icons.add,
              color: Colors.blue,
            ),
            onPressed: () {},
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: BottomAppBar( //bottom navigation bar on scaffold
          color:Colors.redAccent,
          elevation: 0.0,
          shape: const CircularNotchedRectangle(), //shape of notch
          notchMargin: 5, //notche margin between floating button and bottom appbar
          child: Row( //children inside bottom appbar
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              iconSize: 35.0,
              isSelected: currentPageIndex == 1,
              icon: const Icon(Icons.home, color: Colors.black),
              selectedIcon: const Icon(Icons.home_outlined, color: Colors.blue),
              onPressed: () {
                setState(() {
                  currentPageIndex = 1;
                });
              },
            ),
            IconButton(
              iconSize: 35.0,
              isSelected: currentPageIndex == 2,
              icon: const Icon(Icons.wallet, color: Colors.black),
              selectedIcon: const Icon(Icons.wallet_outlined, color: Colors.blue),
              onPressed: () {
                setState(() {
                  currentPageIndex = 2;
                });
              },
            ),
            const SizedBox(width: 33.0),
            IconButton(
              tooltip: 'Search',
              iconSize: 35.0,
              isSelected: currentPageIndex == 3,
              icon: const Icon(Icons.class_, color: Colors.black),
              selectedIcon: const Icon(Icons.class_outlined, color: Colors.blue),
              onPressed: () {
                setState(() {
                  currentPageIndex = 3;
                });
              },
            ),
            IconButton(
              iconSize: 35.0,
              isSelected: currentPageIndex == 4,
              icon: const Icon(Icons.person, color: Colors.black),
              selectedIcon: const Icon(Icons.person_outlined, color: Colors.blue),
              onPressed: () {
                setState(() {
                  currentPageIndex = 4;
                });
              },
            ),
          ],
        ),
      ),

    );
  }
}
