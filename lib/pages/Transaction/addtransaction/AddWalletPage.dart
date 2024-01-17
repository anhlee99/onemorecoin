import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onemorecoin/commons/Constants.dart';
import 'package:provider/provider.dart';

import '../../../model/WalletModel.dart';
import '../../../utils/Utils.dart';
import '../../../widgets/ShowSwitch.dart';

class AddWalletPage extends StatefulWidget {
  const AddWalletPage({super.key});

  @override
  State<AddWalletPage> createState() => _AddWalletPageState();
}

class _AddWalletPageState extends State<AddWalletPage> {
  bool _isSubmit = false;
  String _icon = "";
  String _currency = "VND" ;
  String _iconCurrency = "assets/images/vietnam.png" ;
  bool _isAddToReport = true;

  final inputName = TextEditingController();
  final inputBalance = TextEditingController();
  double _balance = 0;

  void _onCreateWallet(BuildContext context) {
    if(_isSubmit){

      var wallets = context.read<WalletModelProxy>();
      wallets.add(
          WalletModel(
              wallets.getId(),
              name: inputName.text,
              icon: _icon,
              currency: _currency,
              balance: _balance,
              isReport: _isAddToReport,
          )
      );

      Navigator.pop(context, {
        'name': inputName.text,
        'icon': _icon,
      });
    }
  }

  void checkSubmit() {
    if(inputName.text.isNotEmpty && _icon.isNotEmpty && _balance >= 0){
      setState(() {
        _isSubmit = true;
      });
    }else{
      setState(() {
        _isSubmit = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    inputBalance.text = "0";
    inputName.addListener(checkSubmit);
    inputBalance.addListener(() {
          checkSubmit();
          _balance = inputBalance.text.isEmpty ? 0 : Utils.unCurrencyFormat(inputBalance.text);
        }
    );
  }

  @override
  void dispose() {
    inputName.dispose();
    inputBalance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkSubmit();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // hide keyboard
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text("Thêm ví", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.0),
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      width: 80.0,
                      child: Material(
                        child: InkWell(
                            onTap: () async {
                              dynamic result = await Navigator.of(context).pushNamed("/ListIconPage");
                              if(result != null){
                                setState(() {
                                  _icon = result['icon'];
                                });
                              }
                            },
                            child: CircleAvatar(
                                backgroundColor: !_icon.isEmpty ? Colors.transparent : Colors.grey,
                                radius: 30.0,
                                child: _icon.isEmpty ? Icon(Icons.add, size: 30.0, color: Colors.white) : Image.asset(_icon)
                            )
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: inputName,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Tên ví',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 5.0)),
              Container(
                height: 50.0,
                color: Colors.white,
                child: Material(
                  child: InkWell(
                    onTap: () async {
                      dynamic result = await Navigator.of(context).pushNamed("/ListCurrencyPage");
                      if(result != null){
                        setState(() {
                          _currency = result['currency'];
                          _iconCurrency = result['icon'];
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 80.0,
                          child: Image.asset(_iconCurrency),
                        ),
                        Expanded(
                            child: Text(_currency, style: TextStyle(fontSize: 20.0))
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 5.0)),
              Container(
                height: 50.0,
                color: Colors.white,
                child: Material(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80.0,
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: inputBalance,
                          maxLength: Constants.MAX_LENGTH_AMOUNT_INPUT,
                          inputFormatters: [TextInputFormatter.withFunction((oldValue, newValue)  {
                            String value = newValue.text.isEmpty ? "0" : Utils.currencyFormat(Utils.unCurrencyFormat(newValue.text));
                            return newValue.copyWith(
                                text: value,
                                selection: TextSelection.collapsed(offset: value.length)
                            );
                          })],

                          decoration: const InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(),
                            labelText: 'Số dư ban đầu',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              Container(
                color: Colors.white,
                height: 50.0,
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                    children: [
                      const Expanded(
                        child: Align(
                          alignment: Alignment
                              .centerLeft,
                          child: Text(
                              "Tính vào báo cáo"),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets
                              .only(right: 10.0),
                          child: showSwitch(
                            value: _isAddToReport,
                            onChanged: (value) {
                              setState(() {
                                _isAddToReport =
                                    value;
                              });
                            },
                          )
                      ),
                    ]
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _onCreateWallet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSubmit ? null : Colors.grey,
                    fixedSize: Size(MediaQuery.of(context).size.width - 30, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: const Text('Tạo ví'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
