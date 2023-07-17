import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipencari_app/page/splash_screen/splash_screen.dart';
import 'package:sipencari_app/service/providers/comment/comment_provider.dart';
import 'package:sipencari_app/service/providers/discussion/discussion_provider.dart';
import 'package:sipencari_app/service/providers/location_provider.dart';
import 'package:sipencari_app/service/providers/profile/profile_provider.dart';

import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/view_model/auth/auth_view_model.dart';
import 'package:sipencari_app/view_model/comment/comment_view_model.dart';
import 'package:sipencari_app/view_model/missing/missing_view_model.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthViewModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => ProfileProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => DiscussionProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => LocationProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CommentProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => MissingViewModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => CommentViewModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => CommentViewModel(),
          ),
        ],
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              backgroundColor: whiteColor,
            ),
            home: SplashScreen(),
          ),
        ));
  }
}
