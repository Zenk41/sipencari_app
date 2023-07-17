import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sipencari_app/page/auth/register_page.dart';
import 'package:sipencari_app/page/main_page/main_page.dart';
import 'package:sipencari_app/page/welcome_page/welcome_page.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/view_model/auth/auth_view_model.dart';
import 'package:sipencari_app/widgets/back_button_auth.dart';
import 'package:sipencari_app/widgets/button.dart';
import 'package:sipencari_app/widgets/text_field.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    void showAlertDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Color.fromARGB(255, 242, 167, 167),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            alignment: Alignment.topCenter,
            child: Container(
              height: 80,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.red,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Email dan password salah"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    final provider = Provider.of<AuthViewModel>(context, listen: false);
    final providerConfirm = Provider.of<AuthViewModel>(context);
    var Size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ButtonFloatIcon(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomePage(),
                            ),
                            (route) => false);
                      },
                      icon: ImageIcon(
                        const AssetImage('assets/icons/arrow_back_auth.png'),
                        color: blackColor,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang\nKembali!',
                          style: largeTextStyle,
                          textAlign: TextAlign.left,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ImageIcon(
                            const AssetImage('assets/icons/line_auth.png'),
                            color: blackColor,
                          ),
                        )
                      ]),
                  const SizedBox(
                    height: 50,
                  ),
                  InputTextField(
                    editingController: _emailController,
                    validate: (email) {
                      if (email!.isEmpty) {
                        return "email tidak valid";
                      }
                    },
                    iconPrefix: Icon(
                      FluentIcons.person_20_regular,
                      color: grey3Color,
                    ),
                    hintText: 'email',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InputTextField(
                    obscure: providerConfirm.passVissible,
                    editingController: _passwordController,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return "Sandi tidak sesuai";
                      }
                    },
                    iconPrefix: Icon(
                      FluentIcons.password_20_regular,
                      color: grey3Color,
                    ),
                    hintText: 'password',
                    iconSuffix: IconButton(
                      icon: Icon(
                        providerConfirm.passVissible
                            ? FluentIcons.eye_off_24_filled
                            : FluentIcons.eye_24_filled,
                        color: grey3Color,
                      ),
                      onPressed: () {
                        provider.setPassVissible();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        isLoading
                            ? CircularProgressIndicator()
                            : SizedBox(
                                width: 200,
                                child: Button(
                                  onPress: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    final isValidForm =
                                        formKey.currentState!.validate();
                                    if (isValidForm) {
                                      await Provider.of<AuthViewModel>(context,
                                              listen: false)
                                          .getToken(_emailController.text,
                                              _passwordController.text);
                                      if (providerConfirm.message ==
                                          'internal server error') {
                                        print("wrong email and password");
                                        showAlertDialog();
                                      }
                                      if (providerConfirm.message ==
                                          "validation failed") {
                                        print("validasi gagal");
                                        showAlertDialog();
                                      }
                                      if (providerConfirm.message ==
                                          "login success") {
                                        if (!mounted) return;
                                        Fluttertoast.showToast(
                                          msg:
                                              "Berhasil masuk",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: primaryColor,
                                          textColor: blackColor,
                                          fontSize: 16.0,
                                        );
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainPage(),
                                                ),
                                                (route) => false);
                                      }
                                    }
                                    setState(() {
                                      isLoading =
                                          false; // Set isLoading to false when the execution is finished
                                    });
                                  },
                                  bRadius: BorderRadius.circular(16),
                                  color: primaryColor,
                                  centerText: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Text('Masuk')),
                                ),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: 'Belum punya akun? ',
                              style:
                                  smallTextStyle.copyWith(color: grey3Color)),
                          TextSpan(
                              text: 'Daftar',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => RegisterPage(),
                                      ),
                                      (route) => false);
                                },
                              style:
                                  smallTextStyle.copyWith(color: primaryColor))
                        ]))
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
