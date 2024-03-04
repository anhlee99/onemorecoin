import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onemorecoin/model/GroupModel.dart';
import 'package:onemorecoin/model/StorageStage.dart';
import 'package:onemorecoin/model/WalletModel.dart';
import 'package:onemorecoin/commons/Constants.dart';
import 'package:onemorecoin/utils/Utils.dart';
import 'package:onemorecoin/widgets/AlertDiaLog.dart';
import 'package:onemorecoin/widgets/ShowSwitch.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../Objects/AlertDiaLogItem.dart';
import '../../../model/TransactionModel.dart';



class AddTransaction extends StatefulWidget {
  final TransactionModel? transactionModel;
  const AddTransaction({
    super.key,
    this.transactionModel
  });

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {

  final amountField = TextEditingController();
  double _amount = 0;
  String _currency = "VND";
  late final FocusNode _amountFocusNode = FocusNode();
  String _noteValue = '';
  bool _isCleanAmount = false;
  late GroupModel _selectedGroup;
  DateTime _dateTime = DateTime.now();

  DateTime _notificationDateTime = DateTime.now();
  bool _isNotification = false;
  late WalletModel _selectedWallet = context.read<WalletModelProxy>().getAll()[0];
  bool _isShowFull = false;
  bool _isAddToReport = false;
  bool _isSubmit = false;
  bool _isEdit = false;
  bool _isSubmitEdit = false;

  bool _loading = false;

  void isShowFull() {
    setState(() {
      _isShowFull = true;
    });
  }

  void _moveToListGroupPage(BuildContext context) async {
    dynamic result = await Navigator.of(context).pushNamed("/ListGroupPage", arguments: {
      'title': "Chọn nhóm",
    });

    if(result != null){
      setState(() {
        _selectedGroup = result['item'];
      });
    }

  }

  void _moveToAddNotePage(BuildContext context) async {
    print("_selectedGroup.id ${_selectedGroup.id}");
    dynamic result = await Navigator.of(context).pushNamed("/AddNotePage", arguments: {
      'note': _noteValue,
      'groupId': _selectedGroup.id,
    });

    if(result != null){

      if(_amount == 0 && result['amount'] != null){
        _amount = result['amount'];
        amountField.text = Utils.currencyFormat(_amount);
      }

      if(_selectedGroup.id == 0 && result['groupModel'] != null){
        _selectedGroup = result['groupModel'];
      }

      setState(() {
        _noteValue = result['note'];
      });
    }

  }

  List<AlertDiaLogItem> _getListAlertDialogSelectDate(BuildContext context) {
    return [
      AlertDiaLogItem(text: "Hôm nay", okOnPressed: () async {
        setState(() {
          _dateTime = DateTime.now();
        });
      }),
      AlertDiaLogItem(text: "Hôm qua", okOnPressed: () async {
        setState(() {
          _dateTime = DateTime.now().subtract(const Duration(days: 1));
        });
      }),
      AlertDiaLogItem(text: "Tuỳ chọn", okOnPressed: () async {
        _moveToDateSelectPage(context);
      }),
    ];
  }

  void _moveToDateSelectPage(BuildContext context) async {
    dynamic result = await Navigator.of(context).pushNamed("/DateSelectPage", arguments: {
      'selectDate': _dateTime,
    });

    if(result != null){
      setState(() {
        _dateTime = result['selectDate'];
      });
    }


  }

  void _moveToListWalletPage(BuildContext context) async {
    dynamic result = await Navigator.of(context).pushNamed("/ListWalletPage", arguments: {
      'wallet': _selectedWallet,
    });

    if(result != null){
      setState(() {
        _selectedWallet = result['wallet'];
        _currency = _selectedWallet.currency!;
      });
    }
  }

  void _moveToAddNotificationPage(BuildContext context) async {

    dynamic result = await Navigator.of(context).pushNamed("/AddNotificationPage", arguments: {
      'selectDate': _notificationDateTime,
      'isNotification': _isNotification,
      'submitOnPressed': (value) {
        setState(() {
          _notificationDateTime = value['dateTime'];
          _isNotification = value['isNotification'];
        });
      }
    });

    if(result != null){
      setState(() {
        _selectedWallet = result['wallet'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.transactionModel != null){
      _isEdit = true;
      _isShowFull = true;
      amountField.text = Utils.currencyFormat(widget.transactionModel!.amount!);
      _amount = widget.transactionModel!.amount!;
      _noteValue = widget.transactionModel!.note ?? "";
      _selectedGroup = widget.transactionModel!.group!;
      _dateTime = DateTime.parse(widget.transactionModel!.date!);
      _selectedWallet = context.read<WalletModelProxy>().getById(widget.transactionModel!.walletId!);
      _isNotification = widget.transactionModel!.notifyDate != null;
      if(_isNotification){
        _notificationDateTime = DateTime.parse(widget.transactionModel!.notifyDate!);
      }
      _isAddToReport = widget.transactionModel!.addToReport!;
    }else {
      amountField.text = '0';
      _selectedGroup = GroupModel(0,0, name: "Chọn nhóm", icon: Constants.IMAGE_DEFAULT, type: "expense");
    }
    amountField.addListener(() {
      setState(() {
        _amount = amountField.text.isEmpty ? 0 : Utils.unCurrencyFormat(amountField.text);
        _isCleanAmount = amountField.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    amountField.dispose();
    super.dispose();
  }

  _checkSubmit() {
    if (amountField.text.isNotEmpty && _amount > 0 &&
        _selectedGroup.id != 0 && _selectedWallet.id != 0) {
      _isSubmit = true;
    } else {
        _isSubmit = false;
    }
  }

  _checkSubmitEdit() {
    if(_isEdit){
      if (amountField.text.isEmpty || _amount < 0) {
        return _isSubmitEdit = false;
      }
      if (_amount != widget.transactionModel!.amount) {
        return _isSubmitEdit = true;
      }
      if (_selectedGroup.id != widget.transactionModel!.groupId) {
        return _isSubmitEdit = true;
      }
      if (_selectedWallet.id != widget.transactionModel!.walletId) {
        return _isSubmitEdit = true;
      }
      if (_dateTime.toString() != widget.transactionModel!.date) {
        return _isSubmitEdit = true;
      }
      if (_noteValue != widget.transactionModel!.note) {
        return _isSubmitEdit = true;
      }
      if (_isNotification != (widget.transactionModel!.notifyDate != null)) {
        return _isSubmitEdit = true;
      }
      if (_isNotification && _notificationDateTime.toString() != widget.transactionModel!.notifyDate) {
        return _isSubmitEdit = true;
      }
      if (_isAddToReport != widget.transactionModel!.addToReport) {
        return _isSubmitEdit = true;
      }
      return _isSubmitEdit = false;
    }
  }

  _addTransaction(BuildContext context) {

    if (_isSubmit && !_isEdit) {
      var transactions = context.read<TransactionModelProxy>();
      print("_addTransaction123 ${_dateTime.toString()}");
      transactions.add(
          TransactionModel(
            const Uuid().v4(),
            _selectedWallet.id,
            _selectedGroup.id,
            title: "title",
            amount: _amount,
            unit: _currency,
            type: _selectedGroup.type ?? "expense",
            date: _dateTime.toString(),
            note: _noteValue,
            addToReport: _isAddToReport,
            notifyDate: _isNotification ? _notificationDateTime.toString() : null,
          )
      );

      var wallets = context.read<WalletModelProxy>().getById(_selectedWallet.id);
      double balance = _selectedGroup.type == "expense" ? wallets.balance! - _amount : wallets.balance! + _amount;
      context.read<WalletModelProxy>().updateBalance(wallets, balance);
      Navigator.of(context, rootNavigator: true).pop(context);
    }
  }

  _updateTransaction(BuildContext context) async {
    if (_isSubmitEdit && _isEdit) {
      var transactions = context.read<TransactionModelProxy>();
      print("_updateTransaction ${_dateTime.toString()}");

      // update old wallet
      if(_selectedWallet.id != widget.transactionModel!.walletId){
        print("update wallet");
        var oldWallet = context.read<WalletModelProxy>().getById(widget.transactionModel!.walletId);
        double oldWalletBalance = (_selectedGroup.type == "expense") ? oldWallet.balance! + widget.transactionModel!.amount! : oldWallet.balance! - widget.transactionModel!.amount!;
        context.read<WalletModelProxy>().updateBalance(oldWallet, oldWalletBalance);
      }
      var newWallet = context.read<WalletModelProxy>().getById(_selectedWallet.id);
      double newBalance = (_selectedGroup.type == "expense") ? newWallet.balance! - _amount : newWallet.balance! + _amount;
      context.read<WalletModelProxy>().updateBalance(newWallet, newBalance);

      transactions.update(
          TransactionModel(
            widget.transactionModel!.id,
            _selectedWallet.id,
            _selectedGroup.id,
            title: "title",
            amount: _amount,
            unit: _currency,
            type: _selectedGroup.type ?? "expense",
            date: _dateTime.toString(),
            note: _noteValue,
            addToReport: _isAddToReport,
            notifyDate: _isNotification ? _notificationDateTime.toString() : null,
          )
      );

      Navigator.of(context, rootNavigator: true).pop(context);
    }
  }

    @override
    Widget build(BuildContext context) {
      const Color colorHide = Color(0xFF8A8787);
      const Color colorActive = Colors.black;
      _checkSubmit();
      _checkSubmitEdit();
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(!_isEdit ? 'Thêm giao dịch' : 'Sửa giao dịch',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              leading: TextButton(
                child: const Text(
                    'Hủy',
                    style: TextStyle(
                      fontSize: 16.0,
                    )
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(context);
                },
              ),
            ),
            backgroundColor: Colors.grey[100],
            body: SafeArea(
              // padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: ListView(
                        dragStartBehavior: DragStartBehavior.down,
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                            .onDrag,
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 15.0)),
                          Container(
                            color: Colors.white,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border.symmetric(
                                  horizontal: BorderSide(
                                    color: colorHide,
                                    //                   <--- border color
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              child: Column(
                                  children: [
                                    SizedBox(
                                      height: 15.0,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 80.0,
                                          ),
                                          Expanded(
                                            child: Container(
                                                child: Align(
                                                  alignment: Alignment
                                                      .centerLeft,
                                                  child: Text("Số tiền",
                                                      style: TextStyle(
                                                          color: colorHide)),
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 70.0,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 80.0,
                                            padding: EdgeInsets.all(10),
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all(
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              color: colorHide,
                                                              // your color here
                                                              width: 1,
                                                            ),
                                                            borderRadius: BorderRadius
                                                                .circular(5)))
                                                ),
                                                onPressed: () => {},
                                                child: Text(_currency)
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: colorHide,
                                                      //                   <--- border color
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                ),
                                                child: TextField(
                                                  controller: amountField,
                                                  focusNode: _amountFocusNode,
                                                    maxLength: Constants.MAX_LENGTH_AMOUNT_INPUT,
                                                  inputFormatters: [TextInputFormatter.withFunction((oldValue, newValue)  {
                                                    String value = newValue.text.isEmpty ? "0" : Utils.currencyFormat(Utils.unCurrencyFormat(newValue.text));
                                                    return newValue.copyWith(
                                                        text: value,
                                                        selection: TextSelection.collapsed(offset: value.length)
                                                    );
                                                  })],
                                                  onChanged: (text) {
                                                    if (text.isNotEmpty && text[0] == '0') {
                                                      amountField.text = text.substring(1);
                                                    }
                                                  },
                                                  autofocus: _isEdit ? false : true,
                                                  // showCursor: false,
                                                  textAlignVertical: TextAlignVertical
                                                      .center,
                                                  decoration: InputDecoration(
                                                    counterText: "",
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(top: 0),
                                                    suffixIcon: _isCleanAmount
                                                        ?  IconButton(
                                                      icon: const Icon(
                                                          Icons.cancel,
                                                          color: colorHide),
                                                      onPressed: () => {
                                                        amountField.clear(),
                                                      },
                                                    ) : null,
                                                  ),
                                                  style: const TextStyle(fontSize: 30.0),
                                                  keyboardType: TextInputType
                                                      .number,
                                                ),
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 70.0,
                                      child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () async {
                                              _moveToListGroupPage(context);
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                    width: 80.0,
                                                    child: CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor: Colors.transparent,
                                                        child: Image.asset(_selectedGroup.icon ?? Constants.IMAGE_DEFAULT)
                                                    )
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      decoration: const BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(
                                                            color: colorHide,
                                                            //                   <--- border color
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                    _selectedGroup
                                                                        .name ??
                                                                        "Chọn nhóm",
                                                                    style:
                                                                    TextStyle(
                                                                        color: _selectedGroup
                                                                            .name ==
                                                                            null
                                                                            ? colorHide
                                                                            : colorActive,
                                                                        fontSize: 22.0)),
                                                              ),
                                                            ),
                                                            Container(
                                                                margin: const EdgeInsets
                                                                    .only(
                                                                    right: 10.0),
                                                                child: const Align(
                                                                  child: Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      color: colorHide,
                                                                      size: 20),
                                                                )
                                                            ),
                                                          ]
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                    Container(
                                      constraints: const BoxConstraints(
                                        minHeight: 50.0,
                                      ),
                                      child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () async {
                                              _moveToAddNotePage(context);
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 80.0,
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Icon(Icons.notes),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    constraints: const BoxConstraints(
                                                      minHeight: 50.0,
                                                    ),
                                                    decoration: const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          color: colorHide,
                                                          //                   <--- border color
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  _noteValue
                                                                      .isNotEmpty
                                                                      ? _noteValue
                                                                      : "Ghi chú",
                                                                maxLines: 4,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            )
                                                        ),
                                                        Container(
                                                            margin: const EdgeInsets
                                                                .only(
                                                                right: 10.0),
                                                            child: const Align(
                                                              child: Icon(Icons
                                                                  .arrow_forward_ios,
                                                                  color: colorHide,
                                                                  size: 20),
                                                            )
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50.0,
                                      child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              showAlertDialog(
                                                context: context,
                                                optionItems: _getListAlertDialogSelectDate(context),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 80.0,
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Icon(Icons
                                                      .calendar_month_outlined),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          color: colorHide,
                                                          //                   <--- border color
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(Utils
                                                                  .getStringFormatDayOfWeek(
                                                                  _dateTime)),
                                                            ),
                                                          ),
                                                          Container(
                                                              margin: const EdgeInsets
                                                                  .only(
                                                                  right: 10.0),
                                                              child: const Align(
                                                                child: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    color: colorHide,
                                                                    size: 20),
                                                              )
                                                          ),
                                                        ]
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50.0,
                                      child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              _moveToListWalletPage(context);
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 80.0,
                                                  child: CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor: Colors.transparent,
                                                    child: Image.asset(_selectedWallet.icon ?? Constants.IMAGE_DEFAULT),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  _selectedWallet
                                                                      .name ??
                                                                      "Cash",
                                                                  style: TextStyle(
                                                                      color: _selectedWallet
                                                                          .name ==
                                                                          null
                                                                          ? colorHide
                                                                          : colorActive)),
                                                            )
                                                        ),
                                                        Container(
                                                            margin: const EdgeInsets
                                                                .only(
                                                                right: 10.0),
                                                            child: const Align(
                                                              child: Icon(Icons
                                                                  .arrow_forward_ios,
                                                                  color: colorHide,
                                                                  size: 20),
                                                            )
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 15.0)),
                          !_isShowFull
                              ? Container(
                            color: Colors.white,
                            height: 50,
                            child: Container(
                                decoration: const BoxDecoration(
                                  border: Border.symmetric(
                                    horizontal: BorderSide(
                                      color: colorHide,
                                      //                   <--- border color
                                      width: 0.2,
                                    ),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      isShowFull();
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: colorHide,
                                            //                   <--- border color
                                            width: 0.2,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Icon(Icons.add),
                                          Padding(padding: EdgeInsets.only(
                                              left: 10.0)),
                                          Text("Thêm chi tiết")
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          )
                              : Column(
                            children: [
                              Container(
                                color: Colors.white,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(
                                        color: colorHide,
                                        //                   <--- border color
                                        width: 0.2,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50.0,
                                        child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                _moveToAddNotificationPage(
                                                    context);
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 80.0,
                                                    padding: const EdgeInsets
                                                        .all(10.0),
                                                    child: Icon(Icons.alarm),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      // decoration: const BoxDecoration(
                                                      //   border: Border(
                                                      //     bottom: BorderSide(
                                                      //       color: colorHide, //                   <--- border color
                                                      //       width: 0.5,
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                    _isNotification
                                                                        ? Utils
                                                                        .getStringFormatDateAndTime(
                                                                        _notificationDateTime)
                                                                        : "Đặt nhắc nhở"),
                                                              ),
                                                            ),
                                                            Container(
                                                                margin: const EdgeInsets
                                                                    .only(
                                                                    right: 10.0),
                                                                child: const Align(
                                                                  child: Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      color: colorHide,
                                                                      size: 20),
                                                                )
                                                            ),
                                                          ]
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(
                                  top: 15.0)),
                              Container(
                                color: Colors.white,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(
                                        color: colorHide,
                                        //                   <--- border color
                                        width: 0.2,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50.0,
                                        child: Row(
                                          children: [
                                            Padding(padding: EdgeInsets.only(
                                                left: 15.0)),
                                            Expanded(
                                              child: Row(
                                                  children: [
                                                    const Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            "Không tính vào báo cáo"),
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20.0)),
                        ]
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      color: Colors.grey[100],
                      child: !_isEdit
                          ? ElevatedButton(
                        onPressed: () async {
                          context.loaderOverlay.show();
                          await Future.delayed(const Duration(milliseconds: 500));
                          _addTransaction(context);
                          context.loaderOverlay.hide();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isSubmit ? null : Colors.grey,
                          fixedSize: Size(MediaQuery
                              .of(context)
                              .size
                              .width - 20, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: !_loading ? Text('Tạo giao dịch') : CircularProgressIndicator(
                          color: Colors.yellow.withOpacity(0.6),
                          strokeWidth: 3,
                        ),

                      )
                          : ElevatedButton(
                        onPressed: () async {
                          context.loaderOverlay.show();
                          await Future.delayed(const Duration(milliseconds: 500));
                          _updateTransaction(context);
                          context.loaderOverlay.hide();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isSubmitEdit ? null : Colors.grey,
                          fixedSize: Size(MediaQuery
                              .of(context)
                              .size
                              .width - 20, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: Text('Lưu'),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      );
    }
  }



