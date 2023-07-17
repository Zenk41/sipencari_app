import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sipencari_app/models/comment/payload_comment.dart';
import 'package:sipencari_app/service/providers/comment/comment_provider.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/view_model/comment/comment_view_model.dart';
import 'package:sipencari_app/widgets/alert.dart';
import 'package:sipencari_app/widgets/button.dart';
import 'package:sipencari_app/widgets/long_text_field.dart';

class EditCommentPage extends StatefulWidget {
  const EditCommentPage(
      {super.key,
      required this.commentID,
      required this.discussionID,
      required this.message});
  final String commentID;
  final String discussionID;
  final String message;

  @override
  State<EditCommentPage> createState() => _EditCommentPageState();
}

class _EditCommentPageState extends State<EditCommentPage> {
  final formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    _messageController.text = widget.message;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommentViewModel>(context, listen: false);

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
                            "Apakah kamu ingin membatalkan ubah komentar?",
                            "Iya",
                            "assets/small_logo.png");
                      },
                    ),
                    Text(
                      "Ubah Komentar",
                      style: mediumTextStyle,
                    ),
                    Button(
                      color: grey3Color,
                      centerText: Text("Bersihkan"),
                      bRadius: BorderRadius.circular(10),
                      onPress: () {
                        setState(() {
                          _messageController.clear();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                hintText: 'message',
              ),
              const SizedBox(
                height: 15,
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
                              );
                              Provider.of<CommentViewModel>(context,
                                      listen: false)
                                  .putComment(
                                context,
                                comment.message,
                                widget.commentID,
                              );
                              await Future.delayed(const Duration(seconds: 1));
                              if (provider.isNext == "success") {
                                if (!mounted) return;
                                Fluttertoast.showToast(
                                  msg: "Success Edit Comment",
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
                                }).whenComplete(() {
                                  Navigator.pop(context);
                                });
                              }
                            }
                          }

                          setState(() {
                            isLoading =
                                false; // Set isLoading to false when the execution is finished
                          });
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
