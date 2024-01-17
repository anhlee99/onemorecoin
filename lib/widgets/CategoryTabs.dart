import 'package:flutter/material.dart';


class CategoryTabs extends StatefulWidget {
  const CategoryTabs({
    super.key,
    required this.listTab
  });

  final List<String> listTab;
  @override
  State<CategoryTabs> createState() => _CategoryTabs(listTab: listTab);
}

class _CategoryTabs extends State<CategoryTabs> with TickerProviderStateMixin {
  _CategoryTabs({
    required this.listTab
  });

  List<String> listTab;

  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: listTab.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: listTab.length,
        initialIndex: listTab.length - 2,
        child: Column(
          children: [
            // CategoryTabs(listTab: _getListTab(showType)),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                for (final item in listTab)
                  Tab(
                    child: Text(item),
                  ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  for (final item in listTab)
                    ListView(
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: Colors.amber[600],
                          child: Center(child: Text(item)),
                        ),
                        Container(
                          height: 50,
                          color: Colors.amber[500],
                          child: const Center(child: Text('Entry B')),
                        ),
                        Container(
                          height: 50,
                          color: Colors.amber[100],
                          child: const Center(child: Text('Entry C')),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      );
  }
}
