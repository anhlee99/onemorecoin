import 'dart:math';

import 'package:flutter/material.dart';
import 'package:onemorecoin/commons/Constants.dart';
import 'package:onemorecoin/components/MyButton.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:share_plus/share_plus.dart';

import '../Objects/AlertDiaLogItem.dart';
import '../model/BudgetModel.dart';
import '../model/GroupModel.dart';
import '../model/TransactionModel.dart';
import '../model/WalletModel.dart';
import '../widgets/AlertDiaLog.dart';


class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  _removeAllData(BuildContext context ) async {
    showAlertDialog(
      context: context,
      title: Text("Xác nhận xoá toàn bộ dữ liệu?"),
      optionItems: [
        AlertDiaLogItem(
          text: "Xoá",
          textStyle: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.normal
          ),
          okOnPressed: () {
            // var transactions = context.read<TransactionModelProxy>();
            var budgetProxy = context.read<BudgetModelProxy>();
            var groups = context.read<GroupModelProxy>();
            var wallets = context.read<WalletModelProxy>();

            // transactions.deleteAll();
            // transactions.close();
            budgetProxy.deleteAll();
            // budgetProxy.close();
            groups.deleteAll();
            // groups.close();
            wallets.deleteAll();
            // wallets.close();
            // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

            SnackBar snackBar = const SnackBar(
              content: Text("Đã xoá toàn bộ dữ liệu"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

          },
        ),
      ],
      cancelItem: AlertDiaLogItem(
        text: "Huỷ",
        textStyle: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.normal
        ),
        okOnPressed: () {},
      ),
    );
  }


  _makeTestData(BuildContext context ) async {
    var transactions = context.read<TransactionModelProxy>();
    var budgetProxy = context.read<BudgetModelProxy>();
    var groups = context.read<GroupModelProxy>();
    var wallets = context.read<WalletModelProxy>();
    int length = transactions.getAll().length;
    for(var i = length + 1; i < length + 100; i++){
      TransactionModel transaction = TransactionModel(
        i.toString(),
        1,
        1,
        title: "Giao dịch $i",
        amount: Random().nextDouble() * 1000000,
        unit: "VND",
        type: "expense",
        date: DateTime.now().add(Duration(days: Random().nextInt(30 + 100) - 100)).toString(),
        note: "Giao dịch $i",
        addToReport: true,
        notifyDate: DateTime.now().toString(),
      );
      transactions.add(transaction);
    }
    // budgetProxy.deleteAll();
    // budgetProxy.close();
    // groups.deleteAll();
    // groups.close();
    // wallets.deleteAll();
    // wallets.close();
    // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    SnackBar snackBar = const SnackBar(
      content: Text("Đã xoá toàn bộ dữ liệu"),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  void _onShareWithResult(BuildContext context, String subject, String content) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    ShareResult shareResult;
    shareResult = await Share.shareWithResult(content,
        subject: subject,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);

    if (shareResult.status == ShareResultStatus.success) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Chia sẻ thành công"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          title: const Text("Tuỳ chọn"),
          centerTitle: true,
          elevation: 0.0,
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
                children: [
                  const SizedBox(height: 20,),
                  const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 50,
                    child: Icon(Icons.person, size: 50, color: Colors.white,),
                  ),
                  const SizedBox(height: 20,),
                  const Text("Nguyễn Văn A", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 20,),
                ]
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.grey),
                  title: const Text("Cài đặt"),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey,),
                  onTap: () {
                    // Navigator.pushNamed(context, '/Setting');
                  },
                ),
                Divider(
                  color: Colors.grey[300],
                  height: 0.5,
                ),
                ListTile(
                  leading: const Icon(Icons.contact_support, color: Colors.grey),
                  title: const Text("Hỗ trợ"),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey,),
                  onTap: () {
                    Navigator.pushNamed(context, '/profile_support');
                  },
                ),
                Divider(
                  color: Colors.grey[300],
                  height: 0.5,
                ),
                ListTile(
                  leading: const Icon(Icons.share, color: Colors.grey),
                  title: const Text("Giới thiệu"),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey,),
                  onTap: () {
                    // Navigator.pushNamed(context, '/Setting');
                    _onShareWithResult(context, "OneMoreCoin", "https://www.facebook.com/profile.php?id=100010369753030");
                  },
                ),
                Divider(
                  color: Colors.grey[300],
                  height: 0.5,
                ),
              ],
            ),
          ),
          const SizedBox(height: 50,),
          Container(
            color: Colors.white,
            height: 45.0,
            child: MyButton(
                onTap: (){
                  _removeAllData(context);

                },
                child: const Center(
                    child: Text(
                        "Xoá toàn bộ dữ liệu",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                        )
                    )
                )
            ),
          ),

          const SizedBox(height: 50,),
          Container(
            color: Colors.white,
            height: 45.0,
            child: MyButton(
                onTap: (){
                  _makeTestData(context);
                },
                child: const Center(
                    child: Text(
                        "Tạo dự liệu test",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        )
                    )
                )
            ),
          ),

        ],
      ),
    );
  }
}
