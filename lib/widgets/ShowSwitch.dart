import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onemorecoin/Objects/AlertDiaLogItem.dart';

Widget showSwitch({
  bool value = false,
  ValueChanged<bool>? onChanged,
}) {
  TextStyle textStyle = const TextStyle(color: Colors.black);
  if (Platform.isIOS) {
    return CupertinoSwitch(
      // This bool value toggles the switch.
      value: value,
      activeColor: CupertinoColors.systemGreen,
      onChanged: onChanged,
    );
  }

  // todo : showDialog for ios
  return Switch(
    // This bool value toggles the switch.
    value: value,
    onChanged: onChanged,
  );
}

