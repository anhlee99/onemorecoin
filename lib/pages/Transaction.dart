
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onemorecoin/Objects/AlertDiaLogItem.dart';
import 'package:onemorecoin/Objects/TabTransaction.dart';
import 'package:onemorecoin/commons/Constants.dart';
import 'package:onemorecoin/model/GroupModel.dart';
import 'package:onemorecoin/model/StorageStage.dart';
import 'package:onemorecoin/model/WalletModel.dart';
import 'package:onemorecoin/navigations/NavigationBottom_2.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/ListIconPage.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/ListWalletPage.dart';
import 'package:onemorecoin/utils/MyDateUtils.dart';
import 'package:onemorecoin/utils/Utils.dart';
import 'package:onemorecoin/widgets/AlertDiaLog.dart';
import 'package:onemorecoin/widgets/ShowListWallet.dart';
import 'package:onemorecoin/widgets/TransactionItem.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../Objects/ShowType.dart';
import '../model/TransactionModel.dart';
import '../widgets/ShowReportForPeriod.dart';
import 'Transaction/addtransaction/AddWalletPage.dart';
import 'Transaction/addtransaction/ListCurrencyPage.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  static const String routeName = '/Transaction';

  @override
  State createState() => _Transaction();
}

class _Transaction extends State<Transaction> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<Transaction> {

  @override
  bool get wantKeepAlive => true;

  List<TabTransaction> listTab = [];
  final List<Tab> _tabs = <Tab>[];
  late TabController _tabController;
  int totalTab = 20;
  int _tabIndex = 0;
  WalletModel _wallet = WalletModel(0, name: "Tất cả các ví", icon: null, currency: "VND");
  String _transactionViewModel = "date";
  bool _isBackToday = false;

  void _generateListTab(ShowType showType){

    setState(() {
      _isBackToday = false;
      // listTab = Utils.getListTabShowTypeTransaction(showType, totalTab);
      listTab = context.read<TransactionModelProxy>().generateListTabTransactionInTransactionPage(false, showType, _wallet);
      _tabIndex = listTab.length > 2 ? listTab.length  - 2 : 0;
      _tabController = TabController(vsync: this, length: listTab.length, initialIndex: _tabIndex);
    });
    // _tabController.addListener(() {
    //   if(listTab.length - _tabController.index > 5 && !_isBackToday){
    //     // setState(() {
    //     //   _isBackToday = true;
    //     // });
    //     print("Listener triggered...");
    //     _isBackToday = true;
    //   }else if(_isBackToday){
    //     // setState(() {
    //     //   _isBackToday = false;
    //     // });
    //     print("Listener triggered222...");
    //   }
    // });

  }

  List<AlertDiaLogItem> _getListAlertDialogItem(BuildContext context) {
    return [
      AlertDiaLogItem(text: "Khoảng thời gian", okOnPressed: () async {
          await showAlertDialog(
            context: context,
            title: Text("Khoảng thời gian"),
            optionItems: [
              AlertDiaLogItem(text: "Ngày", okOnPressed: ()=> {
                setState(() {
                  _generateListTab(ShowType.date);
                })
              }),
              AlertDiaLogItem(text: "Tuần", okOnPressed: ()=> {
                setState(() {
                  _generateListTab(ShowType.week);
                })
              }),
              AlertDiaLogItem(text: "Tháng", okOnPressed: ()=> {
                setState(() {
                  _generateListTab(ShowType.month);
                })
              }),
              AlertDiaLogItem(text: "Quý", okOnPressed: ()=> {
                setState(() {
                  _generateListTab(ShowType.quarter);
                })
              }),
              AlertDiaLogItem(text: "Năm", okOnPressed: ()=> {
                setState(() {
                  _generateListTab(ShowType.year);
                })
              }),
              AlertDiaLogItem(text: "Tất cả", okOnPressed: ()=> {
                setState(() {
                  _generateListTab(ShowType.all);
                })
              }),
            ],
          );
      }),
      AlertDiaLogItem(
          text: _transactionViewModel == 'date' ? "Xem theo nhóm" : "Xem theo ngày giao dịch",
          okOnPressed: () async {
          setState(() {
            _transactionViewModel = _transactionViewModel == 'date' ? 'group' : 'date';
          });
      }),
    ];
  }

  _renderStickyHeaderTransaction(String date, List<TransactionModel> transactions ) {
    double totalAmount = Utils.sumAmountTransaction(transactions);

    if(_transactionViewModel == 'group'){
      GroupModel? groupModel = transactions[0].group;
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            Center(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    leading: Image.asset(groupModel?.icon ?? Constants.IMAGE_DEFAULT),
                    title: Text(groupModel?.name ?? ""),
                    subtitle: Text("${transactions.length} giao dịch", style: TextStyle(color: Colors.grey[500] )),
                    trailing: Text((totalAmount > 0 ? "+" : "") + Utils.currencyFormat(totalAmount),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0
                        )
                    ),
                  ),
                )
            ),
            Divider(
              height: 1,
                color: Colors.grey[300]
            )
          ],
        ),

      );
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Center(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListTile(
                  leading: FittedBox(
                    fit: BoxFit.fill,
                    child: Container(
                        child: Text(MyDateUtils.getDateInMonthFromString(date).toString(),
                          style: const TextStyle(fontSize: 50.0),
                        )),
                  ),
                  title: Text(MyDateUtils.getNameDayOfWeekFromString(date),
                  ),
                  subtitle: Text(MyDateUtils.getMonthAndYearFromString(date),
                  ),
                  trailing: Text((totalAmount > 0 ? "+" : "") + Utils.currencyFormat(totalAmount),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                      )
                  ),
                ),

              )
          ),
        ],
      ),
    );
  }

  List<Widget> _generateListTabTransaction(BuildContext context, List<TransactionModel> transactions, List<TabTransaction> listTab){
    List<Widget> list = [];
    double amountBefore = 0;
    for (final item in listTab) {
      double amountInPeriod = Utils.sumAmountTransaction(item.transactions);
      list.add(
        PageStorage(
          bucket: PageStorageBucket(),
          child: _generateListTransaction(item.transactions, amountBefore, amountInPeriod),
        )
      );
      amountBefore += amountInPeriod;
    }

    return list;
  }

  Widget _generateListTransaction(List<TransactionModel> transactions, double amountBefore, double amountInPeriod) {
    List<Widget> list = [];
    if(transactions.isEmpty){
      return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Align(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/empty-box.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          const Text("Không có giao dịch nào",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ]
          ),
        );
      });
    }

    return ListView(
      children: [
        if(transactions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 1.0),
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            constraints: const BoxConstraints(
              minHeight: 80,
            ),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text("Số dư đầu kỳ"),
                      ),
                      Flexible(
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text("${Utils.currencyFormat(amountBefore)}", maxLines: 1)
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text("Số dư cuối kỳ"),
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("${Utils.currencyFormat(amountInPeriod)}", maxLines: 1),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 100,
                        ),
                        Container(
                          color: Colors.grey[300],
                          height: 2,
                          child: const SizedBox(
                            width: 150,
                          ),
                        )
                      ],
                    )
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 100,
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("${(amountBefore + amountInPeriod > 0 ? "+" : "")}${Utils.currencyFormat(amountBefore + amountInPeriod)}",
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                    child: GestureDetector(
                      onTap: () {
                        _showReportForPeriod(context);
                      },
                      child: Text("Xem báo cáo cho giai đoạn này",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16.0,
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
        if(transactions.isNotEmpty)
          ...(
              _transactionViewModel == "group" ?
              _renderTransactionAccordingGroup(transactions) :
              _renderTransactionAccordingDate(transactions)
          ),
        const SizedBox(height: 100.0)
      ],
    );
  }

  List<Widget> _renderTransactionAccordingDate(List<TransactionModel> transactions) {

    List<Widget> result = [];
    Map<String, List<TransactionModel>> map = {};
    for (final item in transactions) {
      DateTime day = MyDateUtils.dateOnly(DateTime.parse(item.date ?? ""));
      if (map.containsKey(day.toString())) {
        map[day.toString()]!.add(item);
      } else {
        map[day.toString()] = [item];
      }
    }
    for(final key in map.keys){
      result.add(Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: StickyHeader(
          header: _renderStickyHeaderTransaction(key, map[key]!),
          content: Column(
            children: [
              for (final item in map[key]!)
                TransactionItem(transaction: item),
            ],
          ),
        ),
      ));
    }
    return result;
  }

  List<Widget> _renderTransactionAccordingGroup(List<TransactionModel> transactions) {

    List<Widget> result = [];
    Map<String, List<TransactionModel>> map = {};
    for (final item in transactions) {
      String groupId = item.groupId.toString();
      if (map.containsKey(groupId)) {
        map[groupId]!.add(item);
      } else {
        map[groupId] = [item];
      }
    }
    for(final key in map.keys){
      result.add(Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: StickyHeader(
          header: _renderStickyHeaderTransaction(key, map[key]!),
          content: Column(
            children: [
              for (final item in map[key]!)
                TransactionItem(transaction: item, showType: 'group',),
            ],
          ),
        ),
      ));
    }
    return result;
  }

  List<Tab> getTabs() {
    _tabs.clear();
    for (int i = 0; i < listTab.length; i++) {
      _tabs.add(
        Tab(
          child: Text(listTab[i].name),
        ),
      );
    }
    return _tabs;
  }

  void _selectWallet(BuildContext context) async {

    ShowListWalletPage(context, wallet: _wallet).then((value) => {
      if(value != null && value['wallet'] != null){
        if(value['wallet'].id != _wallet.id){
          // setState(() {
          //   _wallet = context.read<TransactionModelProxy>().walletModel;
          //   listTab = context.read<TransactionModelProxy>().generateListTabTransactionInTransactionPage(false, context.read<TransactionModelProxy>().showType, value['wallet']);
          // })
        }
      }
    });
  }

  void _showReportForPeriod(BuildContext context) async {
    ShowReportForPeriod(context, tabIndex: _tabController.index);
  }

  @override
  void initState() {
    super.initState();
    print("init  Transaction ");
    // _wallet = context.read<TransactionModelProxy>().walletModel;
    _generateListTab(ShowType.date);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    _wallet = context.read<TransactionModelProxy>().walletModel;
    listTab = context.read<TransactionModelProxy>().listTab;
    var transactions = context.watch<TransactionModelProxy>().getTransactionByWalletId(_wallet.id);
    if(_wallet.id == 0){
      double totalAmount = context.read<WalletModelProxy>().getAll().fold(0, (previousValue, element) => previousValue + element.balance!);
      _wallet.balance = totalAmount;
    }

    print("build Transaction ${transactions.length}");
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child:  AppBar(
                actions: [
                  // IconButton(
                  //   icon: const Icon(Icons.search),
                  //   tooltip: 'Tìm kiếm',
                  //   onPressed: () {
                  //   },
                  // ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    tooltip: 'Tuỳ chọn',
                    onPressed: () {
                      showAlertDialog(
                        context: context,
                        optionItems: _getListAlertDialogItem(context),
                      );
                    },
                  ),
                ],
                flexibleSpace: SizedBox(
                  width: double.infinity,
                  child: Center(
                      child: Column(
                        children: [
                          Text("Số dư",
                            style: const TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey
                            ),
                          ),
                          Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(Utils.currencyFormat(_wallet.balance!),
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black
                                  ),
                                ),
                              )
                          ),
                          Material(
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 155),
                              height: 30,
                              margin: const EdgeInsets.only(bottom: 3.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: InkWell(
                                  onTap: () {
                                    _selectWallet(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _wallet.id == 0 ?  Icon(Icons.language_outlined, color: Colors.green,) : CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Image.asset(_wallet.icon ?? Constants.IMAGE_DEFAULT),
                                      ),
                                      Flexible(
                                        child:FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(_wallet.name ?? ""),
                                        ),
                                      ),
                                      Icon(Icons.arrow_drop_down_sharp, color: Colors.grey,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )

                        ],
                      )
                  ),
                ),
              ),
            ),
            body: DefaultTabController(
              length: listTab.length,
              child: Stack(
                children: [
                  Column(
                    children: [
                      // CategoryTabs(listTab: _getListTab(showType)),
                      Container(
                        height: 50,
                        color: Colors.white,
                        child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            tabs: getTabs()
                        ),
                      ),
                      Expanded(
                        child: PageStorage(
                          bucket: PageStorageBucket(),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              ..._generateListTabTransaction(context, [], listTab),
                              // for (final item in listTab)
                              //   PageStorage(
                              //     bucket: PageStorageBucket(),
                              //     child: _generateListTransaction(transactions, item),
                              //   )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if(_isBackToday)
                    Positioned(
                      top: 35.0,
                      right: 10.0,
                      child: CircleAvatar(
                      radius: 15.0,
                      backgroundColor: Colors.grey,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _tabIndex = listTab.length > 2 ? listTab.length  - 2 : 0;
                            _tabController.animateTo(_tabIndex);
                            _isBackToday = false;
                          });
                        },
                        child: Icon(Icons.keyboard_double_arrow_right, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}

