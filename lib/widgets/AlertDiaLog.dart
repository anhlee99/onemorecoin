import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onemorecoin/Objects/AlertDiaLogItem.dart';

Future<void> showAlertDialog({
  required BuildContext context,
    Widget? title,
    Widget? content,
    String? cancelActionText,
    String? defaultActionText,
    VoidCallback? defaultAction,
    List<AlertDiaLogItem>? optionItems,
    AlertDiaLogItem? cancelItem,
}) async {
  TextStyle textStyle = const TextStyle(color: Colors.blue, fontWeight: FontWeight.normal);
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          if (cancelActionText != null)
            FlatButton(
              child: Text(cancelActionText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text(defaultActionText!),
              onPressed: () => Navigator.of(context).pop(true),
           ),
        ],
      ),
    );
  }

  // todo : showDialog for ios
  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: title,
      message: content,
      actions: <Widget>[
          if (defaultActionText != null)
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () => {
                defaultAction?.call(),
                Navigator.of(context).pop(context),
              },
              child: Text(defaultActionText, style: textStyle),
            ),

          if (optionItems != null)
          for (final item in optionItems)
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () => {
                Navigator.of(context).pop(context),
                item.okOnPressed.call(),
              },
              child: Text(item.text, style: item.textStyle ?? textStyle),
            ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () => {
          Navigator.of(context).pop(context),
          cancelItem?.okOnPressed.call(),
        },
        child: Text(cancelItem?.text ?? "Huỷ",
          style: cancelItem?.textStyle
        ),
      ),
    ),
  );
}

class FlatButton extends StatelessWidget {
  const FlatButton({
    super.key,
    required this.onPressed,
    this.child,
  });
  final Function onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
