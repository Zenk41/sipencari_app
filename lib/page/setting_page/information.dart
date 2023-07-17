import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dev_icons/dev_icons.dart';

class Information extends StatelessWidget {
  final String studentName = 'Ardhi Ramadhani';
  final Uri linkedinURL = Uri(
      scheme: 'https',
      host: 'www.linkedin.com',
      path: '/in/ardhi-ramadhani-a630b9144');
  final Uri githubURL =
      Uri(scheme: 'https', host: 'www.github.com', path: '/zenk41');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Informasi', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/big_logo.png',
                    width: 150,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Dibuat oleh: ${studentName}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    '© 2023 Sipencari. All rights reserved.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(height: 35),
                Center(
                  child: Text(
                    '50419978',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Dosen Pembimbing :',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(height: 5),
                Center(
                  child: Text(
                    'DR. HASMA RASJID, SKom.,MMSI',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Informatika',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Universitas Gunadarma',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(height: 35),
                Center(
                  child: Text(
                    'Hubungi saya di:',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => _launchURL(linkedinURL),
                      child: Icon(
                        DevIcons.linkedinPlain,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _launchURL(githubURL),
                      child: Icon(
                        DevIcons.githubOriginal,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void _launchURL(Uri url) async {
    try {
      await launchUrl(url);
    } catch (e) {
      throw 'Error launching URL: $e';
    }
  }
}
