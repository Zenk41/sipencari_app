import 'package:email_validator/email_validator.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sipencari_app/models/auth/data_register_model.dart';
import 'package:sipencari_app/page/auth/login_page.dart';
import 'package:sipencari_app/page/main_page/main_page.dart';
import 'package:sipencari_app/page/welcome_page/welcome_page.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/view_model/auth/auth_view_model.dart';
import 'package:sipencari_app/widgets/back_button_auth.dart';
import 'package:sipencari_app/widgets/button.dart';
import 'package:sipencari_app/widgets/text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordController2 = TextEditingController();
  bool isLoading = false;

  void showBottom(String errorText) {
    showModalBottomSheet<void>(
      backgroundColor: whiteColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "assets/Indikator.png",
                    ),
                  ),
                ),
                Image.asset(
                  "assets/small_logo.png",
                  height: 50,
                  fit: BoxFit.fitWidth,
                ),
                Text(
                  "${errorText} ",
                  style: mediumTextStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Gunakan Email ini untuk masuk",
                  style: mediumTextStyle.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Button(
                  onPress: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false);
                  },
                  bRadius: BorderRadius.circular(16),
                  color: primaryColor,
                  centerText: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Text('Masuk')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthViewModel>(context, listen: false);
    final providerConfirm = Provider.of<AuthViewModel>(context);
    var Size = MediaQuery.of(context).size;

    String _saveData = '';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Column(children: [
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
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Buat akun \nbaru!',
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
              editingController: _nameController,
              validate: (name) {
                if (name!.isEmpty) {
                  return "name required";
                }
              },
              iconPrefix: Icon(
                FluentIcons.chart_person_20_filled,
                color: grey3Color,
              ),
              hintText: 'nama mu',
            ),
            const SizedBox(
              height: 15,
            ),
            InputTextField(
              editingController: _emailController,
              validate: (email) {
                if (email != null && !EmailValidator.validate(email)) {
                  return "invalid email";
                }
              },
              iconPrefix: Icon(
                FluentIcons.person_20_regular,
                color: grey3Color,
              ),
              hintText: 'emailmu@gmail.com',
            ),
            const SizedBox(
              height: 15,
            ),
            InputTextField(
              obscure: providerConfirm.passVissible,
              editingController: _passwordController,
              validate: (value) {
                final characterRegExp = RegExp(r'^.{8,}$');
                final lowercaseRegExp = RegExp('(?=.*[a-z])');
                final uppercaseRegExp = RegExp('(?=.*[A-Z])');
                final numberRegExp = RegExp('(?=.*[0-9])');
                if (value!.isEmpty) {
                  return "required";
                } else {
                  if (!characterRegExp.hasMatch(value)) {
                    return "8 or more character required";
                  }
                  if (!lowercaseRegExp.hasMatch(value)) {
                    return "lowercase required";
                  }
                  if (!uppercaseRegExp.hasMatch(value)) {
                    return "uppercase required";
                  }
                  if (!numberRegExp.hasMatch(value)) {
                    return "number required";
                  }
                }
                _saveData = value;
                print(value);
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
              height: 15,
            ),
            InputTextField(
              editingController: _passwordController2,
              obscure: providerConfirm.passVissible2,
              validate: (value) {
                if (value!.isEmpty) {
                  return "required";
                } else if (value != _saveData) {
                  return "password doesn't match";
                }
              },
              iconPrefix: Icon(
                FluentIcons.password_20_filled,
                color: grey3Color,
              ),
              iconSuffix: IconButton(
                icon: Icon(
                  providerConfirm.passVissible2
                      ? FluentIcons.eye_off_24_filled
                      : FluentIcons.eye_24_filled,
                  color: grey3Color,
                ),
                onPressed: () {
                  provider.setPassVissible2();
                },
              ),
              hintText: 'konfirmasi password',
            ),
            SizedBox(
              height: 10,
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
                                final users = RegisterModel(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                await Provider.of<AuthViewModel>(context,
                                        listen: false)
                                    .getAllRegister(
                                  context,
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                );

                                if (provider.isNext == "success") {
                                  if (!mounted) return;

                                  Fluttertoast.showToast(
                                    msg: "Berhasil Mendaftar",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: primaryColor,
                                    textColor: blackColor,
                                    fontSize: 16.0,
                                  );
                                  
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                  );
                                } else if (provider.isNext == "email") {
                                  showBottom("Email sudah terdaftar");
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
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Text('Daftar')),
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: 'Sudah punya akun? ',
                        style: smallTextStyle.copyWith(color: grey3Color)),
                    TextSpan(
                        text: 'Masuk',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                                (route) => false);
                          },
                        style: smallTextStyle.copyWith(color: primaryColor))
                  ]))
                ],
              ),
            ),
          ]),
        ),
      )),
    );
  }
}
