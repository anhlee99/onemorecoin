
import 'package:flutter/material.dart';
import 'package:onemorecoin/model/GroupModel.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNewGroupPage extends StatefulWidget {
  const AddNewGroupPage({super.key});

  @override
  State<AddNewGroupPage> createState() => _AddNewGroupPageState();
}
enum SingingCharacter { income, expense }

class _AddNewGroupPageState extends State<AddNewGroupPage> {

  final inputName = TextEditingController();
  SingingCharacter? _character = SingingCharacter.expense;
  bool _isSubmit = false;
  String _icon = "";

  void checkSubmit() {
    if(inputName.text.isNotEmpty && _icon.isNotEmpty){
      setState(() {
        _isSubmit = true;
      });
    }else{
      setState(() {
        _isSubmit = false;
      });
    }
  }

  void _onCreateGroup(BuildContext context) {
    if(_isSubmit){
      var groups = context.read<GroupModelProxy>();
      int id = groups.getId();
      groups.add(
          GroupModel(
              id,
              id,
              name: inputName.text,
              icon: _icon,
              type: _character == SingingCharacter.expense ? "expense" : "income"
          )
      );

      Navigator.pop(context, {
        'name': inputName.text,
        'icon': _icon,
        'type': _character == SingingCharacter.expense ? "expense" : "income"
      });
    }
  }

  @override
  void initState() {
    super.initState();
    inputName.addListener(checkSubmit);
  }

  @override
  void dispose() {
    inputName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkSubmit();
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('Nhóm mới', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // hide keyboard
          },
          child: SafeArea(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                const Padding(padding: EdgeInsets.only(top: 2.0)),
                Container(
                  margin: EdgeInsets.only(top: 15.0),
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
                            labelText: 'Tên nhóm',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 5.0)),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          setState(() {
                            _character = SingingCharacter.expense;
                          });
                        },
                        title: const Text('Khoản chi'),
                        leading: Radio<SingingCharacter>(
                          value: SingingCharacter.expense,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() {
                            _character = SingingCharacter.income;
                          });
                        },
                        title: const Text('Khoản thu'),
                        leading: Radio<SingingCharacter>(
                          value: SingingCharacter.income,
                          groupValue: _character,
                          onChanged: (SingingCharacter? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10.0)),
                Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child:  ElevatedButton(
                    onPressed: () {
                      _onCreateGroup(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSubmit ? null : Colors.grey,
                      fixedSize: Size(MediaQuery.of(context).size.width - 30, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Text('Tạo nhóm'),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }


}
