import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sipencari_app/models/missing/data_discussion_model.dart';
import 'package:sipencari_app/page/main_page/location_picker.dart';
import 'package:sipencari_app/page/main_page/main_page.dart';
import 'package:sipencari_app/service/providers/discussion/discussion_provider.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/view_model/missing/missing_view_model.dart';
import 'package:sipencari_app/widgets/alert.dart';
import 'package:sipencari_app/widgets/button.dart';
import 'package:sipencari_app/widgets/long_text_field.dart';
import 'package:sipencari_app/widgets/text_field.dart';

class AddMissing extends StatefulWidget {
  const AddMissing({super.key, this.disModel2});
  final DiscussionModel2? disModel2;

  @override
  State<AddMissing> createState() => _AddMissingState();
}

class _AddMissingState extends State<AddMissing> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  bool permissionGranted = false;
  bool isLoading = false;
  List<XFile>? _imageFileList = [];

  final Map<String, String> categoryTranslations = {
    'Goods': 'Barang Hilang',
    'Pet': 'Peliharaan Hilang',
    'Human': 'Orang Hilang',
  };

  final List<String> itemsCategory = [
    'Goods',
    'Pet',
    'Human',
  ];
  String _selectedStatus = 'NotFound';
  String? selectedCategory;

  final formKey = GlobalKey<FormState>();

  String _selectedPrivacy = 'Public';

  @override
  Widget build(BuildContext context) {
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

    double heightQ = MediaQuery.of(context).size.height;
    double widthQ = MediaQuery.of(context).size.width;
    final provider = Provider.of<MissingViewModel>(context, listen: false);
    final providerlatlng = Provider.of<MissingViewModel>(context);

    return Scaffold(
      backgroundColor: whiteColor,
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
                            "Apakah kamu ingin membatalkan postingan?",
                            "Iya",
                            "assets/small_logo.png");
                      },
                    ),
                    Text(
                      "POST KEHILANGAN",
                      style: mediumTextStyle,
                    ),
                    Button(
                      color: grey3Color,
                      centerText: Text("Bersihkan"),
                      bRadius: BorderRadius.circular(10),
                      onPress: () {
                        setState(() {
                          _contentController.clear();
                          _titleController.clear();
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          )),
      body: SizedBox(
        height: heightQ,
        width: widthQ,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kategori",
                  style: mediumTextStyle,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Icon(
                          Icons.list,
                          size: 16,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            'Pilih Kategori',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: itemsCategory.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          categoryTranslations[item]!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    value: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Judul",
                  style: mediumTextStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                LongTextFieldInput(
                  iconPrefix: Icon(FluentIcons.app_title_20_filled),
                  hintText: "Judul kehilangan",
                  editingController: _titleController,
                  maxLength: 100,
                  validate: (title) {
                    if (title!.isEmpty) {
                      return "required";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Deskripsi kehilangan",
                  style: mediumTextStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                LongTextFieldInput(
                  obscure: false,
                  iconPrefix: Icon(FluentIcons.content_view_20_filled),
                  hintText: "Deskripsi kehilangan",
                  editingController: _contentController,
                  validate: (content) {
                    if (content!.isEmpty) {
                      return "required";
                    }
                    return null;
                  },
                  maxLength: 1000,
                  minLine: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Lokasi",
                  style: mediumTextStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text("Latitude : ${widget.disModel2?.lat}"),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Longtitude : ${widget.disModel2?.lng}")
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Privasi",
                        style: mediumTextStyle,
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: Radio<String>(
                          activeColor: primaryColor,
                          value: 'Public',
                          groupValue: _selectedPrivacy,
                          onChanged: (value) {
                            setState(() {
                              _selectedPrivacy = value!;
                            });
                          },
                        ),
                        title: Text('Publik', style: smallTextStyle),
                        contentPadding: EdgeInsets.zero,
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: Radio<String>(
                          activeColor: primaryColor,
                          value: 'Private',
                          groupValue: _selectedPrivacy,
                          onChanged: (value) {
                            setState(() {
                              _selectedPrivacy = value!;
                            });
                          },
                        ),
                        title: Text('Privat', style: smallTextStyle),
                        contentPadding: EdgeInsets.zero,
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status",
                        style: mediumTextStyle,
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: Radio<String>(
                          activeColor: primaryColor,
                          value: 'NotFound',
                          groupValue: _selectedStatus,
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                            });
                          },
                        ),
                        title: Text('Dicari', style: smallTextStyle),
                        contentPadding: EdgeInsets.zero,
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: Radio<String>(
                          activeColor: primaryColor,
                          value: 'Found',
                          groupValue: _selectedStatus,
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                            });
                          },
                        ),
                        title: Text('Ditemukan', style: smallTextStyle),
                        contentPadding: EdgeInsets.zero,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
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
                            "POSTING",
                            style: mediumTextStyle,
                          ),
                          bRadius: BorderRadius.circular(10),
                          onPress: () async {
                            setState(() {
                              isLoading =
                                  true; // Set isLoading to true when the button is clicked
                            });

                            final isValidForm =
                                formKey.currentState!.validate();
                            if (isValidForm) {
                              if (_imageFileList!.isNotEmpty &&
                                  _titleController.text.isNotEmpty &&
                                  selectedCategory != null &&
                                  _contentController.text.isNotEmpty) {
                                final missing = DiscussionModel1(
                                  title: _titleController.text,
                                  content: _contentController.text,
                                  category: selectedCategory!,
                                  discussion_pictures: _imageFileList,
                                  status: _selectedStatus,
                                  privacy: _selectedPrivacy,
                                );
                                Provider.of<MissingViewModel>(context,
                                        listen: false)
                                    .postDiscussion(
                                  context,
                                  missing.title,
                                  missing.content,
                                  missing.category,
                                  missing.discussion_pictures!,
                                  widget.disModel2!.lat,
                                  widget.disModel2!.lng,
                                  missing.status,
                                  missing.privacy,
                                );
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                if (provider.isNext == "success") {
                                  if (!mounted) return;
                                  Fluttertoast.showToast(
                                    msg: "Success Post",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: primaryColor,
                                    textColor: whiteColor,
                                    fontSize: 16.0,
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return MainPage();
                                    }),
                                    (route) => false,
                                  );
                                }
                              } else {
                                String message = 'Tolong masukkan (';
                                if (_imageFileList!.isEmpty) {
                                  message += "|Gambar| ";
                                }
                                if (selectedCategory == null) {
                                  message += "|Kategori| ";
                                }
                                if (_titleController.text.isEmpty) {
                                  message += "|judul| ";
                                }
                                if (_contentController.text.isEmpty) {
                                  message += "|deskripsi kehilangan| ";
                                }
                                message += ")";

                                Fluttertoast.showToast(
                                  msg: message,
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
