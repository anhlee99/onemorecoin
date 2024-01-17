import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSupportPage extends StatelessWidget {
  const ProfileSupportPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Hỗ trợ"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.support_agent, color: Colors.grey),
              title: const Text("0123456789", style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message: "Thời gian làm việc từ : 8h - 17h",
                child: Icon(Icons.info, color: Colors.grey),
              ),
              onTap: () async {
                _makePhoneCall("0123456789");
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.facebook, color: Colors.grey),
              title: const Text("Fanpage OneMoreCoin", style: TextStyle(fontWeight: FontWeight.bold),),
              onTap: () async {
                launchUrl(Uri.parse("https://www.facebook.com/profile.php?id=100010369753030"));
              },
            ),
          )
        ],
      )
    );
  }
}

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}


