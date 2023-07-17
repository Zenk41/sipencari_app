import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sipencari_app/page/main_page/main_page.dart';
import 'package:sipencari_app/service/providers/profile/profile_provider.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/view_model/auth/auth_view_model.dart';
import 'package:sipencari_app/widgets/alert.dart';
import 'package:sipencari_app/widgets/button.dart';
import 'package:sipencari_app/widgets/text_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({
    super.key,
  });

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final formKey = GlobalKey<FormState>();

  final _passwordOldController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordController2 = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    String _saveData = '';
    final provider = Provider.of<AuthViewModel>(context, listen: false);
    final providerConfirm = Provider.of<AuthViewModel>(context);
    Future showAlertDialog(final String label, final Color color,
        final String content, final String label2, final String picture) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Alert(
              labelButton2: label2,
              titleColor: color,
              contentApproval: content,
              labelButton: label,
              colorButton: color,
              picture: picture,
              onClicked: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return MainPage();
                  }),
                  (route) => false,
                );
              },
            );
          });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                    color: Colors.red,
                    centerText: Text("Batal"),
                    bRadius: BorderRadius.circular(10),
                    onPress: () {
                      showAlertDialog(
                          "Tidak",
                          whiteColor,
                          "Apakah kamu ingin membatalkan ubah password?",
                          "Iya",
                          "assets/small_logo.png");
                    },
                  ),
                  Text(
                    "Ubah Password",
                    style: mediumTextStyle,
                  ),
                  Button(
                    color: grey3Color,
                    centerText: Text("Bersihkan"),
                    bRadius: BorderRadius.circular(10),
                    onPress: () {
                      setState(() {
                        _passwordOldController.clear();
                        _passwordController.clear();
                        _passwordController2.clear();
                      });
                    },
                  )
                ],
              ),
            ),
          )),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: ListView(
            children: [
              Text(
                "Password lama",
                style: mediumTextStyle,
              ),
              SizedBox(
                height: 10,
              ),
              InputTextField(
                obscure: providerConfirm.passVissibleOld,
                editingController: _passwordOldController,
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
                },
                iconPrefix: Icon(
                  FluentIcons.password_20_regular,
                  color: grey3Color,
                ),
                hintText: 'password lama',
                iconSuffix: IconButton(
                  icon: Icon(
                    providerConfirm.passVissibleOld
                        ? FluentIcons.eye_off_24_filled
                        : FluentIcons.eye_24_filled,
                    color: grey3Color,
                  ),
                  onPressed: () {
                    provider.setPassVissibleOld();
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Password baru",
                style: mediumTextStyle,
              ),
              SizedBox(
                height: 10,
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
                hintText: 'password baru',
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
              Text(
                "Konfirmasi Password baru",
                style: mediumTextStyle,
              ),
              SizedBox(
                height: 10,
              ),
              InputTextField(
                editingController: _passwordController2,
                obscure: providerConfirm.passVissible2,
                validate: (value) {
                  print(value);
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
                height: 30,
              ),
              Column(
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
                                Provider.of<AuthViewModel>(context,
                                        listen: false)
                                    .changePassword(
                                        context,
                                        _passwordOldController.text,
                                        _passwordController2.text);
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                if (providerConfirm.isNext == 'success') {
                                  if (!mounted) return;

                                  Fluttertoast.showToast(
                                      msg: "Sukses menyimpan password",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: primaryColor,
                                      textColor: whiteColor,
                                      fontSize: 16.0);
                                  Provider.of<ProfileProvider>(context,
                                          listen: false)
                                      .fetchProfil(context);
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (context) => const MainPage()));
                                } else if (providerConfirm.isNext !=
                                    'success') {
                                  if (!mounted) return;

                                  Fluttertoast.showToast(
                                      msg: providerConfirm.isNext!,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: primaryColor,
                                      textColor: whiteColor,
                                      fontSize: 16.0);
                                  Provider.of<ProfileProvider>(context,
                                          listen: false)
                                      .fetchProfil(context);
                          
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
                                child: Text('SIMPAN')),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
