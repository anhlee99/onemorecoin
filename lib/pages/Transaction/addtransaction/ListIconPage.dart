import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ListIconPage extends StatelessWidget {
  const ListIconPage({super.key});


  @override
  Widget build(BuildContext context) {
    List<String> icons = [
      "assets/images/default.png",
      "assets/images/icon_wallet_primary.png",
      "assets/images/icon_wallet_primary.png",
      "assets/images/icon_wallet_primary.png",
      "assets/images/icon_wallet_primary.png",
      "assets/images/icon_wallet_primary.png",
      "assets/images/icon_wallet_primary.png",
      "assets/images/icon_wallet_primary.png",
      "assets/images/icon_wallet_primary.png",
      "assets/images/icon_wallet_primary.png",
      "assets/images/icon_wallet_primary.png",
    ];
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Icon', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: ModalScrollController.of(context),
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 5,
                children: <Widget>[
                  for (var i = 0; i < icons.length; i++)
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, {
                          'icon': icons[i]
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(icons[i]),
                        color: Colors.grey[100],
                      ),
                    ),
                ],
              ),
            ),
          ],
        )

        ,
      )
    );
  }
}
