import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onemorecoin/commons/Constants.dart';
import 'package:onemorecoin/model/GroupModel.dart';
import 'package:provider/provider.dart';
import 'package:slide_switcher/slide_switcher.dart';

class ListGroupPage extends StatefulWidget {

  final String? title;
  final String? type;
  const ListGroupPage({
    super.key,
     this.title,
     this.type = 'all'
  });

  static const String routeName = '/ListGroupPage';

  @override
  State<ListGroupPage> createState() => _ListGroupPageState();
}


class _ListGroupPageState extends State<ListGroupPage> {

  late List<GroupModel> listGroup;

  String _tabSelect = "expense";

  List<String> tabsValue = ['expense', 'income'];
  Map<String, String> tabs = {
    'expense': 'Khoản chi',
    'income': 'Khoản thu',
  };

  @override
  void initState() {
    super.initState();
    if(widget.type == 'all'){
      tabsValue = ['expense', 'income'];
      tabs = {
        'expense': 'Khoản chi',
        'income': 'Khoản thu',
      };
    }
    if(widget.type == 'expense'){
      tabsValue = ['expense'];
      tabs = {
        'expense': 'Khoản chi',
      };
    }
    if(widget.type == 'income'){
      tabsValue = ['income'];
      tabs = {
        'income': 'Khoản thu',
      };
    }

  }

  Widget _buildListGroup(List<GroupModel> listGroup){
    listGroup = listGroup.where((element) => element.type == _tabSelect).toList();
    return ListView.builder(
      controller: ModalScrollController.of(context),
      itemCount: listGroup.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 5),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                print("${listGroup[index].name}");
                Navigator.pop(context, {
                  'item': listGroup[index]
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 60,
                        child: SizedBox(
                          child: Center(
                            child: CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(listGroup[index].icon ?? Constants.IMAGE_DEFAULT),
                            )
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${listGroup[index].name}", style: TextStyle(fontWeight: FontWeight.bold),),
                          // Text("Thu nhập", style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
        );
      },
    );
  }

  void _moveToAddNewGroup(BuildContext context) async {
    dynamic result = await Navigator.of(context).pushNamed("/AddNewGroupPage");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listGroup = context.watch<GroupModelProxy>().getAll();
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(widget.title ?? 'Danh sách nhóm', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {

              },
            )],
        ),
        body: SafeArea(
          child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 2.0)),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  height: 60,
                  child: Center(
                    child: SlideSwitcher(
                      children: [
                        for (final key in tabs.keys)
                        Text(
                          tabs[key] ?? "",
                          style: TextStyle(
                              fontSize: 15,
                              color: _tabSelect == key
                                  ? Colors.black.withOpacity(0.9)
                                  : Colors.grey),
                        ),
                        // Text(
                        //   'Khoản thu',
                        //   style: TextStyle(
                        //       fontSize: 15,
                        //       color: _tabSelect == key
                        //           ? Colors.black.withOpacity(0.9)
                        //           : Colors.grey),
                        // ),
                      ],
                      onSelect: (int index) => setState(() => _tabSelect = tabsValue[index]),
                      containerColor: Colors.grey[200]!,
                      slidersColors: [Colors.white],
                      containerBorderRadius: 5,
                      indents: 3,
                      containerHeight: 30,
                      containerWight: 315,
                    ),
                    // child:  ToggleButtons(
                    //   onPressed: (int index) {
                    //     setState(() {
                    //       // The button that is tapped is set to true, and the others to false.
                    //       for (int i = 0; i < _selectedTabs.length; i++) {
                    //         _selectedTabs[i] = i == index;
                    //       }
                    //       if(index == 0) {
                    //         setState(() {
                    //           _tabSelect = "expense";
                    //         });
                    //       } else {
                    //         setState(() {
                    //           _tabSelect = "income";
                    //         });
                    //       }
                    //     });
                    //   },
                    //   borderRadius: const BorderRadius.all(Radius.circular(8)),
                    //   selectedBorderColor: Colors.red[700],
                    //   selectedColor: Colors.white,
                    //   fillColor: Colors.red[200],
                    //   color: Colors.red[400],
                    //   constraints: const BoxConstraints(
                    //     minHeight: 40.0,
                    //     minWidth: 120.0,
                    //   ),
                    //   isSelected: _selectedTabs,
                    //   children: fruits,
                    // ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 5.0)),
                Container(
                  color: Colors.white,
                  height: 60,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _moveToAddNewGroup(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 80,
                              child: Center(
                                child: Icon(Icons.add_circle_sharp, color: Colors.green),
                              )
                          ),
                          Text("Nhóm mới", style: TextStyle(color: Colors.green),),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: _buildListGroup(listGroup)
                )
              ]
          ),
        )

    );
  }
}
