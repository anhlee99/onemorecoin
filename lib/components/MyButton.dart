

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  const MyButton({super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = Colors.white
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: widget.backgroundColor,
        child: InkWell(
            onTap: widget.onTap,
            child: widget.child
        ),
      )
    );
  }
}
