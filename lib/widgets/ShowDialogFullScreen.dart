import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onemorecoin/Objects/NavigationTransitionType.dart';
import 'package:onemorecoin/pages/Transaction/addtransaction/AddTransaction.dart';

Future<T?> showDialogFullScreen<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  int duration = 0,
  NavigationTransitionType transitionType = NavigationTransitionType.none,
}) async {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration:   Duration(milliseconds: duration),
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          // document:
          https://api.flutter.dev/flutter/widgets/AnimatedWidget-class.html

          if(transitionType == NavigationTransitionType.fade){
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }
          if(transitionType == NavigationTransitionType.bottomToTop){
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          }
          if(transitionType == NavigationTransitionType.rightToLeft){
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          }
          if(transitionType == NavigationTransitionType.topToBottom){
            const begin = Offset(0.0, -1.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          }
          if(transitionType == NavigationTransitionType.scale){
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          }
          return child;
        },
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return builder(context);
        },
      ),
    );
  }
