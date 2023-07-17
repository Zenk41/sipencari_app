import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:email_validator/email_validator.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sipencari_app/page/main_page/main_page.dart';
import 'package:sipencari_app/service/providers/profile/profile_provider.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/view_model/auth/auth_view_model.dart';
import 'package:sipencari_app/widgets/alert.dart';
import 'package:sipencari_app/widgets/button.dart';
import 'package:sipencari_app/widgets/text_field.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({
    super.key,
    required this.emailProfile,
    required this.nameProfile,
    required this.addressProfile,
  });
  final String emailProfile;
  final String nameProfile;
  final String addressProfile;
  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    _nameController.text = widget.nameProfile;
    _emailController.text = widget.emailProfile;
    _addressController.text = widget.addressProfile;
    super.initState();
  }

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
                          "Apakah kamu ingin membatalkan ubah data?",
                          "Iya",
                          "assets/small_logo.png");
                    },
                  ),
                  Text(
                    "Ubah data",
                    style: mediumTextStyle,
                  ),
                  SizedBox(
                    width: 40,
                  ),
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
                "Nama",
                style: mediumTextStyle,
              ),
              SizedBox(
                height: 10,
              ),
              InputTextField(
                maxLength: 100,
                editingController: _nameController,
                validate: (value) {
                  final characterRegExp = RegExp(r'^.{4,}$');
                  if (value!.isEmpty) {
                    return "required";
                  } else {
                    if (!characterRegExp.hasMatch(value)) {
                      return "4 or more character required";
                    }
                  }
                },
                iconPrefix: Icon(
                  FluentIcons.notebook_question_mark_24_regular,
                  color: grey3Color,
                ),
                hintText: 'name',
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Email",
                style: mediumTextStyle,
              ),
              SizedBox(
                height: 10,
              ),
              InputTextField(
                editingController: _emailController,
                validate: (value) {
                  if (value != null && !EmailValidator.validate(value)) {
                    return "invalid email";
                  }
                },
                iconPrefix: Icon(
                  Icons.attach_email_rounded,
                  color: grey3Color,
                ),
                hintText: 'email',
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Alamat",
                style: mediumTextStyle,
              ),
              SizedBox(
                height: 10,
              ),
              InputTextField(
                maxLength: 50,
                editingController: _addressController,
                validate: (value) {
                  final characterRegExp = RegExp(r'^.{10,}$');
                  if (value!.isEmpty) {
                    return "required";
                  } else {
                    if (!characterRegExp.hasMatch(value)) {
                      return "10 or more character required";
                    }
                  }
                },
                iconPrefix: Icon(
                  Icons.location_on,
                  color: grey3Color,
                ),
                hintText: 'address',
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
                                if (widget.nameProfile == _nameController) {
                                  _nameController.clear();
                                }
                                if (widget.emailProfile == _emailController) {
                                  _emailController.clear();
                                }
                                if (widget.addressProfile ==
                                    _addressController) {
                                  _addressController.clear();
                                }

                                Provider.of<AuthViewModel>(context,
                                        listen: false)
                                    .changeData(
                                        context,
                                        _nameController.text,
                                        _emailController.text,
                                        _addressController.text);
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                if (providerConfirm.isNext == 'success') {
                                  if (!mounted) return;

                                  Fluttertoast.showToast(
                                      msg: "Berhasil Ubah data",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: primaryColor,
                                      textColor: whiteColor,
                                      fontSize: 16.0);
                                  Navigator.of(context).pop();
                                }
                                if (providerConfirm.isNext == "email") {
                                  Fluttertoast.showToast(
                                      msg: "Email Telah digunakan",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
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
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
