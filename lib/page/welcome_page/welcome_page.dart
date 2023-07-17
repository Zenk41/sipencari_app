import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipencari_app/page/auth/login_page.dart';
import 'package:sipencari_app/page/auth/register_page.dart';
import 'package:sipencari_app/page/main_page/main_page.dart';
import 'package:sipencari_app/service/providers/location_provider.dart';
import 'package:sipencari_app/shared/shared.dart';

import '../../widgets/button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final _providerLocaiton =
          Provider.of<LocationProvider>(context, listen: false);
      _providerLocaiton.initUserPosition(context);
    });

    checkLogin();
    super.initState();
  }

  void checkLogin() async {
    final helper = await SharedPreferences.getInstance();
    final token = helper.getString('token');
    if (token != null) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            ),
            (route) => false);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Selamat Datang!',
                  style: largeTextStyle,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Image.asset(
                  'assets/big_logo.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Tandai dan Dapatkan Bantuan untuk Menemukan Yang Hilang dengan Sipencari',
                  style: largeTextStyle,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: Button(
                      onPress: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                      },
                      bRadius: BorderRadius.circular(16),
                      color: primaryColor,
                      centerText: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text('Daftar')),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: ButtonWithBorder(
                      onPress: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                      },
                      color: whiteColor,
                      centerText: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'Masuk',
                            style: TextStyle(color: primaryColor),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
