

import 'dart:ui';

import 'package:flutter/material.dart';

class AlertDiaLogItem {
  AlertDiaLogItem({
    required this.text,
    required this.okOnPressed,
    this.textStyle,
  });

  final String text;
  final VoidCallback okOnPressed;
  TextStyle? textStyle = const TextStyle(color: Colors.blue, fontWeight: FontWeight.normal);

}