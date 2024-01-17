import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ListCurrencyPage extends StatelessWidget {
  const ListCurrencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> currency = {
      "VND": "assets/images/vietnam.png",
      "USD": "assets/images/icon_wallet_primary.png",
      "EUR": "assets/images/icon_wallet_primary.png",
      "JPY": "assets/images/icon_wallet_primary.png",
      "GBP": "assets/images/icon_wallet_primary.png",
      "AUD": "assets/images/icon_wallet_primary.png",
      "CAD": "assets/images/icon_wallet_primary.png",
      "CHF": "assets/images/icon_wallet_primary.png",
      "CNY": "assets/images/icon_wallet_primary.png",
      "HKD": "assets/images/icon_wallet_primary.png",
      "NZD": "assets/images/icon_wallet_primary.png",
      "SEK": "assets/images/icon_wallet_primary.png",
      "KRW": "assets/images/icon_wallet_primary.png",
      "SGD": "assets/images/icon_wallet_primary.png",
      "NOK": "assets/images/icon_wallet_primary.png",
      "MXN": "assets/images/icon_wallet_primary.png",
      "INR": "assets/images/icon_wallet_primary.png",
      "RUB": "assets/images/icon_wallet_primary.png",
      "ZAR": "assets/images/icon_wallet_primary.png",
      "TRY": "assets/images/icon_wallet_primary.png",
      "BRL": "assets/images/icon_wallet_primary.png",
      "TWD": "assets/images/icon_wallet_primary.png",
      "DKK": "assets/images/icon_wallet_primary.png",
      "PLN": "assets/images/icon_wallet_primary.png",
      "THB": "assets/images/icon_wallet_primary.png",
      "IDR": "assets/images/icon_wallet_primary.png",
      "HUF": "assets/images/icon_wallet_primary.png",
      "CZK": "assets/images/icon_wallet_primary.png",
      "ILS": "assets/images/icon_wallet_primary.png",
      "CLP": "assets/images/icon_wallet_primary.png",
      "PHP": "assets/images/icon_wallet_primary.png",
      "AED": "assets/images/icon_wallet_primary.png",
      "COP": "assets/images/icon_wallet_primary.png",
      "SAR": "assets/images/icon_wallet_primary.png",
      "MYR": "assets/images/icon_wallet_primary.png",
      "RON": "assets/images/icon_wallet_primary.png",
      "ARS": "assets/images/icon_wallet_primary.png",
      "BGN": "assets/images/icon_wallet_primary.png",
    };
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('Đơn vị tiền tệ', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          child: ListView(
            controller: ModalScrollController.of(context),
            primary: false,
            children: [
            for (MapEntry<String, String> item in currency.entries)
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context, {
                        'currency': item.key,
                        'icon': item.value,
                      });
                    },
                    child: Container(
                      height: 50.0,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            width: 80.0,
                            child: Image.asset(item.value),
                          ),
                          Text(item.key)
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        )
    );
  }
}
