import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sipencari_app/models/missing/data_discussion_model.dart';
import 'package:sipencari_app/page/main_page/main_page.dart';
import 'package:sipencari_app/service/providers/discussion/discussion_provider.dart';
import 'package:sipencari_app/service/providers/location_provider.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/util/finite_state.dart';
import 'package:sipencari_app/util/image.dart';
import 'package:sipencari_app/view_model/missing/missing_view_model.dart';
import 'package:sipencari_app/widgets/alert.dart';
import 'package:sipencari_app/widgets/button.dart';
import 'package:sipencari_app/widgets/long_text_field.dart';
import 'package:sipencari_app/widgets/text_field.dart';

import '../../models/missing/discussion_model.dart';

class EditMissingPage extends StatefulWidget {
  EditMissingPage({super.key, required this.missingDetail});
  final DiscussionData missingDetail;

  @override
  State<EditMissingPage> createState() => _EditMissingPageState();
}

class _EditMissingPageState extends State<EditMissingPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

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
  bool isLoading = false;
  String selectedCategory = "";

  final formKey = GlobalKey<FormState>();

  String _selectedPrivacy = 'Public';
  String _selectedStatus = 'NotFound';
  @override
  void initState() {
    super.initState();
    _titleController.text = widget.missingDetail.title!;
    _contentController.text = widget.missingDetail.content!;
    selectedCategory = widget.missingDetail.category!;
    _selectedPrivacy = widget.missingDetail.privacy!;

    _selectedStatus = widget.missingDetail.status!;
  }

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
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
          });
    }

    double heightQ = MediaQuery.of(context).size.height;
    double widthQ = MediaQuery.of(context).size.width;
    final provider = Provider.of<MissingViewModel>(context, listen: false);

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
                            "Apakah kamu ingin membatalkan ubah postingan?",
                            "Iya",
                            "assets/small_logo.png");
                      },
                    ),
                    Text(
                      "UBAH POST",
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
                    items: itemsCategory.map((item) {
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
                    value: selectedCategory.isEmpty ? null : selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
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
                InputTextField(
                  iconPrefix: Icon(FluentIcons.app_title_20_filled),
                  hintText: "Judul",
                  editingController: _titleController,
                  maxLength: 100,
                  validate: (title) {
                    if (title!.isEmpty) {
                      return "required";
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Deskripsi Kehilangan",
                  style: mediumTextStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                LongTextFieldInput(
                  obscure: false,
                  iconPrefix: Icon(FluentIcons.content_view_20_filled),
                  hintText: "deskripsi kehilangan",
                  editingController: _contentController,
                  validate: (content) {
                    if (content!.isEmpty) {
                      return "required";
                    }
                  },
                  maxLength: 1000,
                  minLine: 1,
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
                      Text(
                          "Latitude : ${widget.missingDetail.discussionLocation!.lat}"),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "Longtitude : ${widget.missingDetail.discussionLocation!.lng}"),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "Alamat : ${widget.missingDetail.discussionLocation!.locationName}")
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
                SizedBox(
                  height: 20,
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
                                  true;
                            });

                            final isValidForm =
                                formKey.currentState!.validate();
                            if (isValidForm) {
                              if (_titleController.text.isNotEmpty &&
                                  selectedCategory != null &&
                                  _contentController.text.isNotEmpty) {
                                final missing = DiscussionModel(
                                  title: _titleController.text,
                                  lat: widget
                                      .missingDetail.discussionLocation!.lat
                                      .toString(),
                                  lng: widget
                                      .missingDetail.discussionLocation!.lng
                                      .toString(),
                                  content: _contentController.text,
                                  category: selectedCategory,
                                  status: _selectedStatus,
                                  privacy: _selectedPrivacy,
                                );
                                Provider.of<MissingViewModel>(context,
                                        listen: false)
                                    .putDiscussion(
                                  context,
                                  widget.missingDetail.discussionId!,
                                  missing.title,
                                  missing.content,
                                  missing.category,
                                  missing.lat,
                                  missing.lng,
                                  missing.status,
                                  missing.privacy,
                                );
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                if (provider.isNext == "success") {
                                  if (!mounted) return;
                                  Fluttertoast.showToast(
                                    msg: "Success Edit",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: primaryColor,
                                    textColor: whiteColor,
                                    fontSize: 16.0,
                                  );
                                  Navigator.of(context).pop();
                                }
                              } else {
                                String message = 'Tolong masukkan (';
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
}
