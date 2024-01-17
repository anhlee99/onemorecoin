import 'package:flutter/material.dart';
import 'package:onemorecoin/model/TransactionModel.dart';
import 'package:onemorecoin/model/WalletModel.dart';
import 'package:onemorecoin/commons/Constants.dart';
import 'package:onemorecoin/utils/Utils.dart';
import 'package:provider/provider.dart';

class ListWalletPage extends StatefulWidget {
  const ListWalletPage({
    super.key,
    required this.wallet,
    this.showWalletGlobal = false
  });
  final WalletModel wallet;
  final bool showWalletGlobal;

  @override
  State<ListWalletPage> createState() => _ListWalletPageState();
}

class _ListWalletPageState extends State<ListWalletPage> {

  late WalletModel _globalWallet;
  late WalletModel _wallet;
  List<WalletModel> walletsReport = [];
  List<WalletModel> walletsNotReport = [];

  @override
  void initState() {
    super.initState();
    _wallet = widget.wallet;

    _globalWallet = WalletModel(0, name: "Tất cả các ví", icon: null, currency: "VND");
    if(widget.showWalletGlobal){
      double totalAmount = context.read<WalletModelProxy>().getAll().fold(0, (previousValue, element) => previousValue + element.balance!);
      _globalWallet.balance = totalAmount;
    }

  }

  _generateWalletsReport(){
    walletsReport = [];
    walletsNotReport = [];
    var allWallets = context.watch<WalletModelProxy>().getAll();
    for(var i = 0; i < allWallets.length; i++){
      if(allWallets[i].isReport){
        walletsReport.add(allWallets[i]);
      }else{
        walletsNotReport.add(allWallets[i]);
      }
    }
  }

  _navigatorPop(BuildContext context){
    context.read<TransactionModelProxy>().walletModel = _wallet;
    if(Navigator.canPop(context)){
      Navigator.pop(context, {
        'wallet': _wallet,
      });
    }else{
      Navigator.of(context, rootNavigator: true).pop(
          {
            'wallet': _wallet,
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _generateWalletsReport();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // surfaceTintColor: Colors.transparent,
        leadingWidth: 70,
        leading: widget.showWalletGlobal ?  FittedBox(
          fit: BoxFit.scaleDown,
          child: TextButton(
            child: const Text(
                'Đóng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )
            ),
            onPressed: () {
              _navigatorPop(context);
            },
          ),
        ) : null,
        title: Text('Chọn ví', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Container(
            child: ListView(
              children: [
                if(widget.showWalletGlobal)
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    width: double.infinity,
                    child: const Text("Tất cả các ví",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17
                        )
                    ),
                  ),
                if(widget.showWalletGlobal)
                  Container(
                  color: Colors.white,
                  child:  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.language_outlined, color: Colors.green, size: 40,)
                    ),
                    title: Text("${_globalWallet.name}", style: TextStyle(fontSize: 20)),
                    subtitle: Text("${Utils.currencyFormat(_globalWallet.balance!)} ${_globalWallet.currency}"),
                    trailing: Icon(Icons.check_circle, color: _wallet.id == _globalWallet.id ? Colors.green : Colors.grey,),
                    onTap: () {
                      setState(() {
                        _wallet = _globalWallet;
                      });
                      _navigatorPop(context);
                    },
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(top: 20, left: 20),
                  width: double.infinity,
                  child: const Text("Tính vào báo cáo",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 17
                      )
                  ),
                ),
                Container(
                  color: Colors.white,
                  child:  Column(
                      children: walletsReport.map((e) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset(e.icon ?? Constants.IMAGE_DEFAULT),
                      ),
                      title: Text("${e.name}", style: TextStyle(fontSize: 20)),
                      subtitle: Text("${Utils.currencyFormat(e.balance!)} ${e.currency}"),
                      trailing: Icon(Icons.check_circle, color: e.id == _wallet.id ? Colors.green : Colors.grey,),
                      onTap: () {
                        setState(() {
                          _wallet = e;
                        });
                        _navigatorPop(context);
                      },
                    )).toList(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, left: 20),
                  width: double.infinity,
                  child: const Text("Không tính vào báo cáo",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 17
                      )
                  ),
                ),
                Container(
                  color: Colors.white,
                  child:  Column(
                    children: walletsNotReport.map((e) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset(e.icon ?? Constants.IMAGE_DEFAULT),
                      ),
                      title: Text("${e.name}", style: TextStyle(fontSize: 20)),
                      subtitle: Text("${Utils.currencyFormat(e.balance!)} ${e.currency}"),
                      trailing: Icon(Icons.check_circle, color: e.id == _wallet.id ? Colors.green : Colors.grey,),
                      onTap: () {
                        setState(() {
                          _wallet = e;
                        });
                        _navigatorPop(context);
                      },
                    )).toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  color: Colors.white,
                  child:  Column(
                    children: [
                      Material(
                        child: ListTile(
                          leading: Icon(Icons.add_circle, color: Colors.green),
                          title: Text("Thêm ví mới", style: TextStyle(fontSize: 20, color: Colors.green)),
                          onTap: () {
                            Navigator.pushNamed(context, "/AddWalletPage");
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}
