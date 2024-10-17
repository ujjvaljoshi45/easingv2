import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class PhoneNumberDialog extends StatelessWidget {
  final String phoneNumber;

  const PhoneNumberDialog({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Text(
        'Contact Us',
        style: montserrat.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFF4B15), // Main color
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  phoneNumber,
                  style: montserrat.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.white),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: phoneNumber));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Phone number copied to clipboard!')),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: phoneNumber,
                  );
                  await launchUrl(launchUri);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: myOrange, // Main color
                ),
                child: Text('Call',style: montserrat.copyWith(color: Colors.white),),
              ),
              ElevatedButton(
                onPressed: () async {
                  final Uri launchUri = Uri(
                    scheme: "https",
                    path: "wa.me/$phoneNumber",
                  );
                  await launchUrl(launchUri);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: myOrange, // Main color
                ),
                child: Text('WhatsApp',style: montserrat.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Close',
            style: montserrat.copyWith(color: Colors.white),
          ),
        ),
      ],
      backgroundColor: Color(0xFF1E1E1E), // Dialog background color
    );
  }
}
