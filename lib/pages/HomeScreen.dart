import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onemorecoin/Objects/NavigationTransitionType.dart';
import 'package:onemorecoin/components/MyButton.dart';
import 'package:onemorecoin/model/StorageStage.dart';
import 'package:onemorecoin/model/WalletModel.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/ListWalletPage.dart';
import 'package:onemorecoin/utils/MyDateUtils.dart';
import 'package:onemorecoin/utils/Utils.dart';
import 'package:onemorecoin/widgets/HomeReportWidget.dart';
import 'package:onemorecoin/widgets/ShowDialogFullScreen.dart';
import 'package:provider/provider.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../commons/Constants.dart';
import '../model/TransactionModel.dart';
import '../widgets/ShowListWallet.dart';
import '../widgets/ShowReportForPeriod.dart';
import 'Report/ReportForPeriod.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({
    super.key,
    required this.title,
    this.jumpToPage,
  });

  final String title;
  final jumpToPage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _showAmount = true;
  double _totalAllAmount = 0;
  WalletModel _wallet = WalletModel(0, name: "Tất cả các ví", icon: null, currency: "VND");  int chartType = 0;
  late List<TransactionModel> transactionNewest;

  void _selectWallet(BuildContext context) async {

    ShowListWalletPage(context, wallet: _wallet).then((value) => {

      if(value != null && value['wallet'] != null){
        if(value['wallet'].id != _wallet.id){
          setState(() {
            _wallet = value['wallet'];
          })
        }
      }
    });
  }


  void _showReportForPeriod(BuildContext context) async {
    ShowReportForPeriod(context);
  }

  _calculate(){
    // transactions = context.read<TransactionModelProxy>().getAllByWalletId(_wallet.id);
    _wallet = context.read<TransactionModelProxy>().walletModel;
    transactionNewest = context.read<TransactionModelProxy>().getNewest(3);
    double totalAmount = context.read<WalletModelProxy>().getAll().fold(0, (previousValue, element) => previousValue + element.balance!);
    if(_wallet.id == 0){
      _wallet.balance = totalAmount;
    }
    _totalAllAmount = totalAmount;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _calculate();
    print("build HomeScreen");
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leadingWidth: double.infinity,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      Text(_showAmount ? "${Utils.currencyFormat(_totalAllAmount)} đ" : "******",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(_showAmount ? Icons.remove_red_eye : Icons.visibility_off),
                        color: Colors.black,
                        onPressed: () {
                          // Scaffold.of(context).openDrawer();
                          setState(() {
                            _showAmount = !_showAmount;
                          });
                        },
                      ),
                    ],
                  ),
                ),
            ),
            IconButton(
              tooltip: "Thông báo",
              icon: const Icon(Icons.notifications),
              color: Colors.black,
              onPressed: () {
                // Scaffold.of(context).openDrawer();
              },
            ),
          ],
        ),
        // title: const Text('HomeScreen'),
      ),
      body: ListView(
         children: [
           Container(
             margin: const EdgeInsets.symmetric( horizontal: 10.0),
             padding: const EdgeInsets.all(10.0),
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(10.0),
             ),
             child: Column(
               children: [
                 Container(
                   margin: const EdgeInsets.all(10.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       const Text("Ví của tôi",
                           style: TextStyle(
                             fontSize: 16.0,
                             fontWeight: FontWeight.bold,
                           )
                       ),
                       MyButton(
                         onTap: () {
                           _selectWallet(context);
                         },
                         child: const Text("Xem tất cả",
                           style: TextStyle(
                             fontSize: 13.0,
                             fontWeight: FontWeight.bold,
                             color: Colors.green,
                           ),
                         )
                       ),
                     ],
                   ),
                 ),
                 Divider(
                   color: Colors.grey[300],
                   height: 1,
                   thickness: 1,
                   indent: 10,
                   endIndent: 10,
                 ),
                 Container(
                   padding: const EdgeInsets.all(10.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Row(
                         children: [
                           _wallet.id == 0 ?  Icon(Icons.language_outlined, color: Colors.green, size: 33,) : CircleAvatar(
                             backgroundColor: Colors.transparent,
                             radius: 20.0,
                             child: Image.asset(_wallet.icon ?? Constants.IMAGE_DEFAULT),
                           ),
                           Container(
                              margin: const EdgeInsets.only(left: 10.0),
                             child: Text(_wallet.name ?? "",
                                 style: TextStyle(
                                   fontSize: 13.0,
                                 )
                             ),
                           )
                         ],
                       ),
                       Text(Utils.currencyFormat(_wallet.balance!),
                         style: const TextStyle(
                           fontSize: 13.0,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ],
                   ),
                 ),
               ],
             ),
           ),
           const SizedBox(
              height: 10.0,
           ),
           Container(
             margin: const EdgeInsets.symmetric( horizontal: 10.0),
             child: Container(
               margin: const EdgeInsets.symmetric(vertical: 10.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   const Text("Báo cáo chi tiêu",
                       style: TextStyle(
                         fontSize: 13.0,
                         fontWeight: FontWeight.bold,
                         color: Colors.grey,
                       )
                   ),
                   MyButton(
                        backgroundColor: Colors.transparent,
                       onTap: () {
                         _showReportForPeriod(context);
                       },
                       child: const Text("Xem tất cả",
                         style: TextStyle(
                           fontSize: 13.0,
                           fontWeight: FontWeight.bold,
                           color: Colors.green,
                         ),
                       )
                   ),
                 ],
               ),
             ),
           ),
           const HomeReportWidget(),
           const SizedBox(
             height: 10.0,
           ),
           Container(
             margin: const EdgeInsets.symmetric( horizontal: 10.0),
             child: Container(
               margin: const EdgeInsets.symmetric(vertical: 10.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   const Text("Giao dịch gần đây",
                       style: TextStyle(
                         fontSize: 13.0,
                         fontWeight: FontWeight.bold,
                         color: Colors.grey,
                       )
                   ),
                   MyButton(
                       backgroundColor: Colors.transparent,
                       onTap: () {
                         widget.jumpToPage(1);
                       },
                       child: const Text("Xem tất cả",
                         style: TextStyle(
                           fontSize: 13.0,
                           fontWeight: FontWeight.bold,
                           color: Colors.green,
                         ),
                       )
                   ),
                 ],
               ),
             ),
           ),
           Container(
             margin: const EdgeInsets.symmetric( horizontal: 10.0),
             padding: const EdgeInsets.all(10.0),
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(10.0),
             ),
             child: Column(
               children: [
                 Container(
                   margin: const EdgeInsets.only(top: 10.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                        if(transactionNewest.isNotEmpty)
                          for(var item in transactionNewest)
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 20.0,
                                child: Image.asset(item.group!.icon ?? Constants.IMAGE_DEFAULT),
                              ),
                              title: Text(item.group!.name ?? "",
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(MyDateUtils.toStringFormat00FromString(item.date ?? ""),
                                style: TextStyle(
                                  fontSize: 13.0,
                                ),
                              ),
                              trailing: Text(Utils.currencyFormat(item.amount ?? 0),
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                       if(!transactionNewest.isNotEmpty)
                         Container(
                             padding: const EdgeInsets.only(bottom:20.0),
                             margin: const EdgeInsets.only(top: 10.0),
                             child: Center(
                               child: Text("Chưa có giao đich nào",
                                 style: TextStyle(
                                   fontSize: 13.0,
                                   fontWeight: FontWeight.normal,
                                   color: Colors.grey,
                                 ),
                               ),
                             )
                         ),
                     ],
                   ),
                 ),
               ],
             ),
           ),
            SizedBox(
              height: 100.0,
            ),
         ],
      ),
    );
  }
}


