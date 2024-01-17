import 'dart:math';

import 'package:flutter/material.dart';

class CustomLinearProgressIndicator extends StatefulWidget {
  const CustomLinearProgressIndicator({
    Key? key,
    this.color = Colors.green,
    this.colors = const [Colors.green, Colors.red],
    this.backgroundColor = Colors.grey,
    this.maxProgressWidth = 100,
    this.value = 0.0,
    this.height = 10,
  }) : super(key: key);

  /// max width in center progress
  final double maxProgressWidth;

  final Color color;
  final List<Color> colors;
  final Color backgroundColor;
  final double value;
  final int height;

  @override
  State<CustomLinearProgressIndicator> createState() =>
      _CustomLinearProgressIndicatorState();
}

class _CustomLinearProgressIndicatorState extends State<CustomLinearProgressIndicator>{
  // late AnimationController controller;
  // late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    // controller = AnimationController(
    //     duration: const Duration(milliseconds: 2000), vsync: this);
    // animation = Tween(begin: 0.0, end: 1.0).animate(controller)
    //   ..addListener(() {
    //     setState(() {
    //       // the state that has changed here is the animation object’s value
    //     });
    //   });
    // controller.repeat();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("animation.value: ${animation.value}");
    Color color = widget.colors[0];
    if (widget.colors.length > 1) {
      color = Color.lerp(widget.colors[0], widget.colors[1], widget.value / widget.maxProgressWidth)!;
    }
    return Center(
        child: Column(
          children: [
            Stack(children: <Widget>[
              Container(
                height: widget.height.toDouble(),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: widget.backgroundColor,
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: min((widget.value / widget.maxProgressWidth), 1.0),
                  heightFactor: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(15.0),
              //     color: Colors.transparent,
              //   ),
              //   // child: FractionallySizedBox(
              //   //   alignment: Alignment.centerLeft,
              //   //   widthFactor: 1/20,
              //   //   child: Padding(
              //   //     padding: const EdgeInsets.all(0.0),
              //   //     child: Container(
              //   //       decoration: BoxDecoration(
              //   //         borderRadius: BorderRadius.circular(15.0),
              //   //         color: Colors.transparent,
              //   //       ),
              //   //       child: Column(
              //   //         children: [
              //   //           Align(
              //   //             child: Container(
              //   //               width: 1,
              //   //               color: Colors.grey[500],
              //   //               child: const SizedBox(
              //   //                 width: 1,
              //   //                 height: 30,
              //   //               ),
              //   //             ),
              //   //           ),
              //   //           // Material(
              //   //           //   child: Container(
              //   //           //     constraints: BoxConstraints(
              //   //           //       maxWidth: 40,
              //   //           //       maxHeight: 30,
              //   //           //     ),
              //   //           //     // alignment: Alignment.lerp(Alignment.topLeft, Alignment.topRight, 11),
              //   //           //     color: Colors.red,
              //   //           //     child: ClipPath(
              //   //           //       clipper: TicketClipper(),
              //   //           //       child: Container(
              //   //           //         color: Colors.grey[400],
              //   //           //         padding: const EdgeInsets.only(left: 3, right: 3, top: 5.0),
              //   //           //         child:  const Center(
              //   //           //           child: Text("Hiện tại", style: TextStyle(color: Colors.white, fontSize: 8)),
              //   //           //         ),
              //   //           //       ),
              //   //           //     ),
              //   //           //   ),
              //   //           // )
              //   //         ],
              //   //       ),
              //   //     ),
              //   //   ),
              //   // ),
              // )
            ]),
            // SizedBox(
            //   child: Container(
            //     alignment: Alignment.lerp(Alignment.topLeft, Alignment.topRight, 11),
            //     color: Colors.red,
            //     height: 30,
            //     width: 40,
            //     child: ClipPath(
            //       clipper: TicketClipper(),
            //       child: Container(
            //         color: Colors.grey[400],
            //         padding: const EdgeInsets.only(left: 3, right: 3, top: 5.0),
            //         child:  const Center(
            //           child: Text("Hiện tại", style: TextStyle(color: Colors.white, fontSize: 8)),
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        )
    );
  }
}


class TicketClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {

    // ve mui ten
    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height / 4),const Radius.circular(0),
    ));
    final clipPath = Path();
    clipPath.moveTo(size.width/2, 0.0);
    clipPath.lineTo(size.width * 0.65, size.height / 4);
    clipPath.lineTo(size.width * 0.35, size.height / 4);
    // combine two path together
    final ticketPath = Path.combine(
      PathOperation.intersect,
      clipPath,
      path,
    );

    // ve hinh chu nhat
    final path2 = Path();
    path2.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height / 4, size.width, size.height * 0.75),const Radius.circular(0),
    ));

    final ticketPath2 = Path.combine(
      PathOperation.union,
      ticketPath,
      path2,
    );

    return ticketPath2;

    return path;
  }

  @override
  bool shouldReclip(TicketClipper oldClipper) => false;
}
