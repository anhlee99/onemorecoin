
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onemorecoin/commons/Constants.dart';
import 'package:onemorecoin/model/BudgetModel.dart';
import 'package:onemorecoin/model/GroupModel.dart';
import 'package:onemorecoin/model/WalletModel.dart';
import 'package:onemorecoin/utils/MyDateUtils.dart';
import 'package:onemorecoin/utils/Utils.dart';
import 'package:provider/provider.dart';

import '../../../Objects/AlertDiaLogItem.dart';
import '../../../widgets/AlertDiaLog.dart';
import '../../../widgets/ShowSwitch.dart';

class AddBudget extends StatefulWidget {
  final BudgetModel? budgetModel;
  const AddBudget({
      super.key,
      this.budgetModel
  });

  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {

  bool _isEdit = false;
  bool _isSubmit = false;
  bool _isSubmitEdit = false;
  double _amount = 0;
  String _currency = "VND";
  final amountField = TextEditingController();
  late final FocusNode _amountFocusNode = FocusNode();
  bool _isCleanAmount = false;
  String _noteValue = "";
  late GroupModel _selectedGroup;
  late WalletModel _selectedWallet = context.read<WalletModelProxy>().getAll()[0];
  late DateTime _fromDate;
  late DateTime _toDate;
  bool _isRepeat = false;
  String _budgetType = "month";


  void _moveToListGroupPage(BuildContext context) async {
    dynamic result = await Navigator.of(context).pushNamed("/ListGroupPage", arguments: {
      'title': "Chọn nhóm",
      'type': "expense",
    });
    if(result != null){
      setState(() {
        _selectedGroup = result['item'];
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

  List<AlertDiaLogItem> _getListAlertDialogSelectDate(BuildContext context) {
    List<DateTime> week = MyDateUtils.getFromToWeek(DateTime.now());
    List<DateTime> month = MyDateUtils.getFromToMonth(DateTime.now());
    List<DateTime> quarter = MyDateUtils.getFromToQuarter(DateTime.now());
    List<DateTime> year = MyDateUtils.getFromToYear(DateTime.now());
    return [
      AlertDiaLogItem(text: "Tuần này (${MyDateUtils.toStringFormat02(week[0])} - ${MyDateUtils.toStringFormat02(week[1])})", okOnPressed: () async {
        setState(() {
          _fromDate = week[0];
          _toDate = week[1];
          _budgetType = "week";
        });
      }),
      AlertDiaLogItem(text: "Tháng này (${MyDateUtils.toStringFormat02(month[0])} - ${MyDateUtils.toStringFormat02(month[1])})", okOnPressed: () async {
        setState(() {
          _fromDate = month[0];
          _toDate = month[1];
          _budgetType = "month";
        });
      }),
      AlertDiaLogItem(text: "Quý này (${MyDateUtils.toStringFormat02(quarter[0])} - ${MyDateUtils.toStringFormat02(quarter[1])})", okOnPressed: () async {
        setState(() {
          _fromDate = quarter[0];
          _toDate = quarter[1];
          _budgetType = "quarter";
        });
      }),
      AlertDiaLogItem(text: "Năm này (${MyDateUtils.toStringFormat02(year[0])} - ${MyDateUtils.toStringFormat02(year[1])})", okOnPressed: () async {
        setState(() {
          _fromDate = year[0];
          _toDate = year[1];
          _budgetType = "year";
        });
      }),
    ];
  }

  _checkSubmit() {
    if(_isEdit){
      return _isSubmit = false;
    }
    if (amountField.text.isEmpty || _amount < 0) {
      return _isSubmit = false;
    }
    if(_selectedGroup.id == 0){
      return _isSubmit = false;
    }
    if(_selectedWallet.id == 0){
      return _isSubmit = false;
    }
    return _isSubmit = true;
  }

  _checkSubmitEdit(){
   if(_isEdit){
     if (amountField.text.isEmpty || _amount < 0) {
       return _isSubmitEdit = false;
     }
     if(_selectedGroup.id == 0){
       return _isSubmitEdit = false;
     }
     if(_selectedWallet.id == 0){
       return _isSubmitEdit = false;
     }
     if(_selectedGroup.id != widget.budgetModel!.groupId){
       return _isSubmitEdit = true;
     }
     if(_selectedWallet.id != widget.budgetModel!.walletId){
       return _isSubmitEdit = true;
     }
     if(_amount != widget.budgetModel!.budget){
       return _isSubmitEdit = true;
     }
     if(_currency != widget.budgetModel!.unit){
       return _isSubmitEdit = true;
     }
     if(_fromDate != DateTime.parse(widget.budgetModel!.fromDate!)){
       return _isSubmitEdit = true;
     }
     if(_toDate != DateTime.parse(widget.budgetModel!.toDate!)){
       return _isSubmitEdit = true;
     }
     if(_noteValue != widget.budgetModel!.note){
       return _isSubmitEdit = true;
     }
     if(_isRepeat != widget.budgetModel!.isRepeat){
       return _isSubmitEdit = true;
     }
   }
    return _isSubmitEdit = false;
  }
  _addBudget(BuildContext context){
    if (_isSubmit && !_isEdit) {
      var budgetProxy = context.read<BudgetModelProxy>();
      print("_addBudget ");
      budgetProxy.add(
          BudgetModel(
            budgetProxy.getId(),
            _selectedWallet.id,
            _selectedGroup.id,
            title: "title",
            budget: _amount,
            unit: _currency,
            type: _selectedGroup.type ?? "expense",
            fromDate: _fromDate.toString(),
            toDate: _toDate.toString(),
            note: _noteValue,
            isRepeat: _isRepeat,
            budgetType: _budgetType
          )
      );
      Navigator.of(context, rootNavigator: true).pop(context);
    }
  }

  _editBudget(BuildContext context){
    if (_isSubmitEdit && _isEdit) {
      var budgetProxy = context.read<BudgetModelProxy>();
      print("_editBudget ");
      budgetProxy.update(
          BudgetModel(
              widget.budgetModel!.id,
              _selectedWallet.id,
              _selectedGroup.id,
              title: "title",
              budget: _amount,
              unit: _currency,
              type: _selectedGroup.type ?? "expense",
              fromDate: _fromDate.toString(),
              toDate: _toDate.toString(),
              note: _noteValue,
              isRepeat: _isRepeat,
              budgetType: _budgetType
          )
      );
      Navigator.of(context, rootNavigator: true).pop(context);
    }
  }

  void _moveToAddNotePage(BuildContext context) async {

    dynamic result = await Navigator.of(context).pushNamed("/AddNotePage", arguments: {
      'note': _noteValue,
    });

    if(result != null){
      setState(() {
        _noteValue = result['note'];
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.budgetModel != null){
      print("Edit Budget ${widget.budgetModel!.id}");
      _isEdit = true;
      _selectedGroup = widget.budgetModel!.group!;
      _selectedWallet = widget.budgetModel!.wallet!;
      amountField.text = Utils.currencyFormat(widget.budgetModel!.budget!);
      _amount = widget.budgetModel!.budget!;
      _currency = widget.budgetModel!.unit!;
      _fromDate = DateTime.parse(widget.budgetModel!.fromDate!);
      _toDate = DateTime.parse(widget.budgetModel!.toDate!);
      _noteValue = widget.budgetModel!.note!;
      _isRepeat = widget.budgetModel!.isRepeat!;
      _budgetType = widget.budgetModel!.budgetType!;
    }else{
      _selectedGroup = GroupModel(0,0, name: "Chọn nhóm", icon: Constants.IMAGE_DEFAULT, type: "expense");
      List<DateTime> month = MyDateUtils.getFromToMonth(DateTime.now());
      _fromDate = month[0];
      _toDate = month[1];
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
    super.dispose();
    amountField.dispose();
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
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text( !_isEdit ? 'Thêm ngân sách' : 'Sửa ngân sách',
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
        body: SafeArea(
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
                                height: 50.0,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      width: 80.0,
                                      child: TextButton(
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty
                                                  .all(
                                                  RoundedRectangleBorder(
                                                      side: const BorderSide(
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
                                              contentPadding: EdgeInsets
                                                  .only(top: 0),
                                              suffixIcon: _isCleanAmount
                                                  ?  IconButton(
                                                icon: const Icon(
                                                    Icons.cancel,
                                                    color: colorHide),
                                                onPressed: () => {
                                                  amountField.clear(),
                                                },
                                              )
                                                  : null,
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
                                                        child: Text("${MyDateUtils.toStringFormat02(_fromDate)} - ${MyDateUtils.toStringFormat02(_toDate)}"),
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
                              )
                            ],
                          )
                      ),
                    ),
                    SizedBox(height: 10,),
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
                                  const Padding(padding: EdgeInsets.only(
                                      left: 10.0)),
                                  Expanded(
                                    child: Row(
                                        children: [
                                          const Expanded(
                                            child: Align(
                                              alignment: Alignment
                                                  .centerLeft,
                                              child: Text(
                                                  "Lặp lại theo kỳ"),
                                            ),
                                          ),
                                          Container(
                                              margin: const EdgeInsets
                                                  .only(right: 10.0),
                                              child: showSwitch(
                                                value: _isRepeat,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isRepeat = value;
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
                    onPressed: () {
                      _addBudget(context);
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
                    child: Text('Tạo ngân sách'),
                  )
                      : ElevatedButton(
                    onPressed: () {
                      _editBudget(context);
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
        ),
      )
    );
  }
}
