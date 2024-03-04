import 'package:flutter/material.dart';
import 'package:onemorecoin/utils/Utils.dart';
import 'package:provider/provider.dart';

import '../../../commons/Constants.dart';
import '../../../model/TransactionModel.dart';

class AddNotePage extends StatefulWidget {
  final String? value;
  final int? groupId;
  final isSuggest;

  const AddNotePage({super.key,
    this.value,
    this.groupId = 0,
    this.isSuggest = false
  });

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class itemNote {
  int id;
  String name;
  String type;
  String icon;
  itemNote(this.id, this.name, this.type, this.icon);
}

class _AddNotePageState extends State<AddNotePage> {

  final inputNote = TextEditingController();
  late List<TransactionModel> suggests  = [];

  @override
  void initState() {
    super.initState();
    inputNote.text = widget.value ?? '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    inputNote.dispose();
  }

  generateSuggest() {
    if(!widget.isSuggest){
      return;
    }
    if (inputNote.text.isNotEmpty && inputNote.text.length < 5) {
      var transactions = context.read<TransactionModelProxy>().getLimitByGroup(widget.groupId ?? 0, 10);
      // var transactions = [];
      List<TransactionModel> suggest = [];
      for (var i = 0; i < transactions.length; i++) {
        if (transactions[i].note!.toLowerCase().contains(inputNote.text.toLowerCase())) {
          suggest.add(transactions[i]);
        }
      }
      setState(() {
        suggests = suggest;
      });
    }else{
      setState(() {
        suggests = [];
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text('Ghi chú',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: TextField(
                        controller: inputNote,
                        autofocus: true,
                        onChanged: (value) {
                          generateSuggest();
                        },
                        maxLines: null,
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {
                          // _addNewGroup(value);
                          Navigator.pop(context, {
                            'note': value,
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nhập ghi chú',
                        ),
                      ),
                    ),
                    if(suggests.isNotEmpty)
                    Expanded(child: Container(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: suggests.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            height: 70.0,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.transparent,
                                child: Image.asset(suggests[index].group?.icon ?? Constants.IMAGE_DEFAULT),
                              ),
                              title: Text(suggests[index].group?.name ?? ''),
                              trailing: Text(Utils.currencyFormat(suggests[index].amount ?? 0),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: suggests[index].type == 'income' ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              subtitle: Text(suggests[index].note ?? ''),
                              onTap: () {
                                Navigator.pop(context, {
                                  'note': suggests[index].note,
                                  'amount': suggests[index].amount,
                                  'groupModel': suggests[index].group,
                                });
                              },
                            ),
                          );
                        },
                      ),
                    )),
                  ],
                )
            ),
          );
        }
    );
  }

}
