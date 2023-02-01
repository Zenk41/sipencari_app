import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sipencari_app/page/auth/login_page.dart';
// import 'package:sipencari_app/service/location_service.dart';
import 'package:sipencari_app/shared/shared.dart';
// import 'package:sipencari_app/view_model/auth_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // testing comment this after done
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(primaryColor: primaryColor),
      home: const LoginPage(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  // return MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(
  //         create: (context) => AuthViewModel(),
  //       ),
  // ChangeNotifierProvider(
  //   create: (context) => Home(),
  // ),
  // ChangeNotifierProvider(
  //   create: (context) => Missing(),
  // ),
  // ChangeNotifierProvider(
  //   create: (context) => MyMissing(),
  // ),
  // ChangeNotifierProvider(
  //   create: (context) => Setting(),
  // ),
  // ],
  // child: GestureDetector(
  //   onTap: () {
  //     FocusScopeNode currentFocus = FocusScope.of(context);
  //     if (!currentFocus.hasPrimaryFocus &&
  //         currentFocus.focusedChild != null) {
  //       FocusManager.instance.primaryFocus!.unfocus();
  //     }
  //   },
  //   child: MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       backgroundColor: whiteColor,
  //     ),
  //     home: WelcomePage(),
  //   ),
  // ));
  // }
}
