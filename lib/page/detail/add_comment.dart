import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sipencari_app/models/comment/payload_comment.dart';
import 'package:sipencari_app/page/main_page/main_page.dart';
import 'package:sipencari_app/service/database/comment/comment.dart';
import 'package:sipencari_app/service/providers/comment/comment_provider.dart';
import 'package:sipencari_app/service/providers/discussion/discussion_provider.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/view_model/auth/auth_view_model.dart';
import 'package:sipencari_app/view_model/comment/comment_view_model.dart';
import 'package:sipencari_app/view_model/missing/missing_view_model.dart';
import 'package:sipencari_app/widgets/alert.dart';
import 'package:sipencari_app/widgets/button.dart';
import 'package:sipencari_app/widgets/long_text_field.dart';
import 'package:sipencari_app/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';

class AddCommentPage extends StatefulWidget {
  const AddCommentPage({super.key, required this.discussionID});
  final String discussionID;

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  @override
  final ImagePicker _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  bool isLoading = false;
  List<XFile>? _imageFileList = [];

  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final provider = Provider.of<CommentViewModel>(context, listen: false);
    final providerlatlng = Provider.of<CommentViewModel>(context);

    double heightQ = MediaQuery.of(context).size.height;
    double widthQ = MediaQuery.of(context).size.width;
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
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
          });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: SafeArea(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            "Apakah kamu ingin membatalkan komentar?",
                            "Iya",
                            "assets/small_logo.png");
                      },
                    ),
                    Text(
                      "Komentar",
                      style: mediumTextStyle,
                    ),
                    Button(
                      color: grey3Color,
                      centerText: Text("Bersihkan"),
                      bRadius: BorderRadius.circular(10),
                      onPress: () {
                        setState(() {
                          _messageController.clear();
                          _imageFileList!.clear();
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          )),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                "Komentar",
                style: mediumTextStyle,
              ),
              SizedBox(
                height: 20,
              ),
              LongTextFieldInput(
                obscure: false,
                maxLength: 500,
                minLine: 1,
                editingController: _messageController,
                validate: (value) {
                  final characterRegExp = RegExp(r'^.{8,}$');
                  if (value!.isEmpty) {
                    return "required";
                  } else {
                    if (!characterRegExp.hasMatch(value)) {
                      return "8 or more character required";
                    }
                  }
                },
                iconPrefix: Icon(
                  Icons.message_outlined,
                  color: grey3Color,
                ),
                hintText: 'komentar',
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gambar",
                      style: mediumTextStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Button(
                      color: primaryColor,
                      centerText: Text("Masukkan Gambar",
                          style: mediumTextStyle.copyWith(fontSize: 11)),
                      bRadius: BorderRadius.circular(5),
                      onPress: () async {
                        _imageFileList = [];
                        Map<Permission, PermissionStatus> statusPermission =
                            await [
                          Permission.location,
                          Permission.camera,
                          Permission.storage,
                          Permission.photos,
                          Permission.audio,
                          Permission.manageExternalStorage,
                          Permission.accessMediaLocation,
                        ].request();

                        _pickMultipleFile();
                      },
                    ),
                    Row(children: [
                      for (var item in _imageFileList!)
                        Expanded(
                          child: Image.file(
                            File(item.path),
                            height: 100,
                            width: 100,
                          ),
                        )
                    ]),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: isLoading
                    ? CircularProgressIndicator() // Show loading indicator
                    : Button(
                        color: primaryColor,
                        centerText: Text(
                          "KIRIM",
                          style: mediumTextStyle,
                        ),
                        bRadius: BorderRadius.circular(10),
                        onPress: () async {
                          setState(() {
                            isLoading =
                                true; // Set isLoading to true when the button is clicked
                          });

                          if (_messageController.value.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Komentar Required",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }

                          final isValidForm = formKey.currentState!.validate();
                          if (isValidForm) {
                            if (_messageController.text.isNotEmpty &&
                                _messageController.text.length >= 8) {
                              final comment = CommentModel(
                                message: _messageController.text,
                                comment_pictures: _imageFileList,
                              );
                              Provider.of<CommentViewModel>(context,
                                      listen: false)
                                  .postComment(
                                context,
                                comment.message,
                                comment.comment_pictures!,
                                widget.discussionID,
                              );
                              await Future.delayed(const Duration(seconds: 1));
                              if (provider.isNext == "success") {
                                if (!mounted) return;
                                Fluttertoast.showToast(
                                  msg: "Success Send Comment",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: primaryColor,
                                  textColor: whiteColor,
                                  fontSize: 16.0,
                                ).whenComplete(() {
                                  Provider.of<CommentProvider>(context)
                                      .fetchComments(
                                    context,
                                    widget.discussionID,
                                  );
                                  Provider.of<DiscussionProvider>(context)
                                      .fetchDiscussion(
                                    "100000",
                                    "0",
                                    context,
                                  );
                                  Provider.of<DiscussionProvider>(context)
                                      .fetchMyDiscussion(
                                    context,
                                  );
                                  Provider.of<DiscussionProvider>(context)
                                      .fetchOneDiscussion(
                                    context,
                                    widget.discussionID,
                                  );
                                }).whenComplete(() {
                                  Navigator.pop(context);
                                });
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "Tolong masukkan komentar lebih dari 8 kata",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          }

                          setState(() {
                            isLoading =
                                false; // Set isLoading to false when the execution is finished
                          });
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickMultipleFile() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      setState(() {
        _imageFileList = images;
      });
    } catch (e) {
      setState(() {
        print(e);
      });
    }
  }
}
