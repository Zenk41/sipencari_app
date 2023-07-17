import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipencari_app/page/setting_page/change_password.dart';
import 'package:sipencari_app/page/setting_page/edit_data.dart';
import 'package:sipencari_app/page/setting_page/information.dart';
import 'package:sipencari_app/page/setting_page/web_view.dart';
import 'package:sipencari_app/page/welcome_page/welcome_page.dart';
import 'package:sipencari_app/service/providers/location_provider.dart';
import 'package:sipencari_app/service/providers/profile/profile_provider.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/util/finite_state.dart';
import 'package:sipencari_app/view_model/auth/auth_view_model.dart';
import 'package:sipencari_app/widgets/alert.dart';
import 'package:badges/badges.dart' as badges;
import 'package:sipencari_app/widgets/pop_picture.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3, left: 3, right: 3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? primaryColor : diffColor,
          shape: BoxShape.circle),
    );
  });
}

class _SettingPageState extends State<SettingPage> {
  late PageController _pageController;
  final ImagePicker _picker = ImagePicker();
  late XFile? imageEdit;

  String? emailProfile;
  String? nameProfile;
  String? addressProfile;

  void initState() {
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
    Future.delayed(Duration.zero, () {
      final _providerProfile =
          Provider.of<ProfileProvider>(context, listen: false);
      _providerProfile.fetchProfil(context).whenComplete(() {
        emailProfile = _providerProfile.profil!.data!.email.toString();
        nameProfile = _providerProfile.profil!.data!.name.toString();
        addressProfile = _providerProfile.profil!.data!.address.toString();
      });
      final _providerLocation =
          Provider.of<LocationProvider>(context, listen: false);
      _providerLocation.initUserPosition(context);
    });

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightt = MediaQuery.of(context).size.height;
    double widthh = MediaQuery.of(context).size.width;
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
                final prefs = await SharedPreferences.getInstance();
                final String token = prefs.getString('token') ?? "";
                prefs.remove("token");
                prefs.setBool("login", false);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const WelcomePage())),
                    (route) => false);
              },
            );
          });
    }

    Future showPictureDialog(
      final String label,
      final Color color,
      final String content,
      final String label2,
      XFile imageUser,
    ) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopUp(
              labelButton2: label2,
              titleColor: color,
              colorButton: primaryColor,
              contentApproval: content,
              labelButton: label,
              widgets: InkWell(
                child: badges.Badge(
                    child: Container(
                      height: heightt * 80 / 800,
                      width: widthh * 80 / 360,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(600),
                        child: Image.file(File(imageUser.path)),
                      ),
                    ),
                    badgeColor: primaryColor,
                    position: badges.BadgePosition.bottomEnd(),
                    badgeContent: SizedBox(
                        width: 15,
                        height: 15,
                        child: Image.asset(
                          "assets/icons/edit_picture.png",
                          color: Colors.white,
                        ))),
              ),
              onClicked: () {
                Provider.of<ProfileProvider>(context, listen: false)
                    .changePicture(context, imageUser)
                    .whenComplete(() {
                  Provider.of<ProfileProvider>(context, listen: false)
                      .fetchProfil(context)
                      .whenComplete(() => Navigator.pop(context));
                });
              },
            );
          });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          SizedBox(
              height: double.infinity,
              child: ListView(
                children: [
                  SizedBox(
                    height: heightt * 40 / 800,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: widthh * 16 / 360, right: widthh * 16 / 360),
                    child: Consumer<ProfileProvider>(
                      builder: (context, value, child) {
                        switch (value.myState) {
                          case MyState.loading:
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: heightt * 80 / 800,
                                  width: widthh * 80 / 360,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(400),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              "assets/icons/picture_deffault.png"))),
                                ),
                                SizedBox(
                                  width: widthh * 20 / 360,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: heightt * 13 / 800),
                                      child: Text(
                                        "-",
                                        style: mediumTextStyle,
                                      ),
                                    ),
                                    Text(
                                      "-",
                                      style: smallTextStyle,
                                    ),
                                  ],
                                )
                              ],
                            );
                          case MyState.loaded:
                            if (value.profil == null) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: heightt * 80 / 800,
                                    width: widthh * 80 / 360,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(400),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/icons/picture_deffault.png"))),
                                  ),
                                  SizedBox(
                                    width: widthh * 20 / 360,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: heightt * 13 / 800),
                                        child: Text(
                                          "-",
                                          style: mediumTextStyle,
                                        ),
                                      ),
                                      Text(
                                        "-",
                                        style: smallTextStyle,
                                      ),
                                    ],
                                  )
                                ],
                              );
                            } else {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Consumer<ProfileProvider>(
                                    builder: (context, value, child) {
                                      switch (value.myState) {
                                        case MyState.loading:
                                          return Container(
                                            height: heightt * 80 / 800,
                                            width: widthh * 80 / 360,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(400),
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "assets/icons/picture_deffault.png"))),
                                          );
                                        case MyState.loaded:
                                          if (value.profil!.data!.picture ==
                                              null) {
                                            return Container(
                                              height: heightt * 80 / 800,
                                              width: widthh * 80 / 360,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          400),
                                                  image: const DecorationImage(
                                                      image: AssetImage(
                                                          "assets/icons/picture_deffault.png"))),
                                            );
                                          } else {
                                            return InkWell(
                                              child: badges.Badge(
                                                  child: Container(
                                                    height: heightt * 80 / 800,
                                                    width: widthh * 80 / 360,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(600),
                                                        image: DecorationImage(
                                                          image:
                                                              CachedNetworkImageProvider(
                                                            value.profil!.data!
                                                                .picture
                                                                .toString(),
                                                          ),
                                                        )),
                                                  ),
                                                  badgeColor: primaryColor,
                                                  position: badges.BadgePosition
                                                      .bottomEnd(),
                                                  badgeContent: SizedBox(
                                                      width: 15,
                                                      height: 15,
                                                      child: Image.asset(
                                                        "assets/icons/edit_picture.png",
                                                        color: Colors.white,
                                                      ))),
                                              onTap: () {
                                                _pickFile().whenComplete(
                                                  () {
                                                    if (imageEdit!
                                                        .path.isNotEmpty) {
                                                      showPictureDialog(
                                                          "Batal",
                                                          primaryColor,
                                                          "Apakah kamu ingin mengganti Poto mu?",
                                                          "Simpan",
                                                          imageEdit!);
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                            //
                                          }
                                        case MyState.failed:
                                          return Container(
                                            height: heightt * 80 / 800,
                                            width: widthh * 80 / 360,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(400),
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "assets/icons/picture_deffault.png"))),
                                          );

                                        default:
                                          return const CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: widthh * 20 / 360,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: heightt * 13 / 800,
                                        ),
                                        child: Text(
                                          value.profil!.data!.name.toString(),
                                          style: mediumTextStyle,
                                        ),
                                      ),
                                      Text(
                                        value.profil!.data!.email.toString(),
                                        style: smallTextStyle,
                                      ),
                                    ],
                                  )
                                ],
                              );
                            }
                          case MyState.failed:
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: heightt * 80 / 800,
                                  width: widthh * 80 / 360,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(400),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              "assets/icons/picture_deffault.png"))),
                                ),
                                SizedBox(
                                  width: widthh * 20 / 360,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: heightt * 13 / 800,
                                      ),
                                      child: Text("-", style: mediumTextStyle),
                                    ),
                                    Text(
                                      "-",
                                      style: smallTextStyle,
                                    ),
                                  ],
                                )
                              ],
                            );
                          default:
                            return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: heightt * 600 / 800,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding:
                          const EdgeInsets.only(top: 4, left: 20, right: 20),
                      children: [
                        SizedBox(height: 30),
                        SizedBox(
                            width: widthh,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: widthh * 16 / 360,
                                        right: widthh * 16 / 360),
                                    child: Text(
                                      "Akun",
                                      style: mediumTextStyle.copyWith(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Consumer<ProfileProvider>(
                                          builder: (context, provider, _) {
                                            return ListTile(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 30, right: 30),
                                              leading: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/icons/edit.png"))),
                                              ),
                                              title: Transform.translate(
                                                offset: const Offset(-10, 0),
                                                child: Text(
                                                  "Ubah Data",
                                                  style: mediumTextStyle,
                                                ),
                                              ),
                                              trailing: Transform.translate(
                                                offset: const Offset(-12, 0),
                                                child: Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.transparent,
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/icons/dot.png"))),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: ((context) =>
                                                            EditAccount(
                                                              emailProfile:
                                                                  emailProfile!,
                                                              nameProfile:
                                                                  nameProfile!,
                                                              addressProfile:
                                                                  addressProfile!,
                                                            ))));
                                              },
                                            );
                                          },
                                        ),
                                        ListTile(
                                          contentPadding: const EdgeInsets.only(
                                              left: 30, right: 30),
                                          leading: Container(
                                            width: 28,
                                            height: 28,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/icons/change_password.png"))),
                                          ),
                                          title: Transform.translate(
                                            offset: const Offset(-10, 0),
                                            child: Text(
                                              "Ubah Password",
                                              style: mediumTextStyle,
                                            ),
                                          ),
                                          trailing: Transform.translate(
                                            offset: const Offset(-12, 0),
                                            child: Container(
                                              width: 12,
                                              height: 12,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/icons/dot.png"))),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        ChangePasswordPage())));
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: widthh * 16 / 360,
                                              right: widthh * 16 / 360),
                                          child: Text(
                                            "Lainnya",
                                            style: mediumTextStyle.copyWith(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ListTile(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 30, right: 30),
                                                leading: Container(
                                                  width: 28,
                                                  height: 28,
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/icons/feedback.png"))),
                                                ),
                                                title: Transform.translate(
                                                  offset: const Offset(-10, 0),
                                                  child: Text(
                                                    "Saran",
                                                    style: mediumTextStyle,
                                                  ),
                                                ),
                                                trailing: Transform.translate(
                                                  offset: const Offset(-12, 0),
                                                  child: Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/icons/dot.png"))),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WebView(
                                                              url:
                                                                  'https://docs.google.com/forms/d/e/1FAIpQLScjWtI0mbvmW3_NmblQrMAxbIjglT0tmYX2ufsvu5UsODyUAg/viewform',
                                                              title: "Saran",
                                                            )),
                                                  );
                                                },
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 30, right: 30),
                                                leading: Container(
                                                  width: 28,
                                                  height: 28,
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/icons/raphael_book.png"))),
                                                ),
                                                title: Transform.translate(
                                                  offset: const Offset(-10, 0),
                                                  child: Text(
                                                    "Panduan Pengguna",
                                                    style: mediumTextStyle,
                                                  ),
                                                ),
                                                trailing: Transform.translate(
                                                  offset: const Offset(-12, 0),
                                                  child: Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/icons/dot.png"))),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WebView(
                                                              url:
                                                                  'https://zenk41.notion.site/Sipencari-Documentation-8ec264a556a7409c99eb533845f0c42c',
                                                              title: "Panduan Pengguna",
                                                            )),
                                                  );
                                                },
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 30, right: 30),
                                                leading: Container(
                                                  width: 28,
                                                  height: 28,
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/icons/information.png"))),
                                                ),
                                                title: Transform.translate(
                                                  offset: const Offset(-10, 0),
                                                  child: Text(
                                                    "Informasi",
                                                    style: mediumTextStyle,
                                                  ),
                                                ),
                                                trailing: Transform.translate(
                                                  offset: const Offset(-12, 0),
                                                  child: Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/icons/dot.png"))),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              Information())));
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    right: 20,
                                                    left: 20),
                                                child: Consumer<AuthViewModel>(
                                                  builder:
                                                      (context, provider, _) {
                                                    return ListTile(
                                                      tileColor: Colors.red,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      //contentPadding: EdgeInsets.only(left: 30, right: 30),
                                                      leading:
                                                          Transform.translate(
                                                        offset:
                                                            const Offset(-2, 0),
                                                        child: Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration: const BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/icons/logout.png"))),
                                                        ),
                                                      ),
                                                      title:
                                                          Transform.translate(
                                                        offset: const Offset(
                                                            -14, 0),
                                                        child: Text(
                                                          "Keluar",
                                                          style: mediumTextStyle
                                                              .copyWith(
                                                                  color:
                                                                      whiteColor),
                                                        ),
                                                      ),
                                                      trailing:
                                                          Transform.translate(
                                                        offset:
                                                            const Offset(-6, 0),
                                                        child: Container(
                                                          width: 12,
                                                          height: 12,
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/icons/dot_white.png")),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        showAlertDialog(
                                                            "Tidak",
                                                            primaryColor,
                                                            "Apakah Kamu Yakin Ingin Keluar?",
                                                            "Iya",
                                                            "assets/small_logo.png");
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: heightt * 40 / 800),
                                                child: Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: widthh * 6 / 360,
                                                      ),
                                                      Image.asset(
                                                        "assets/small_logo.png",
                                                        height: 40,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: heightt * .1,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ])),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        imageEdit = image;
      });
    } catch (e) {
      setState(() {
        print(e);
      });
    }
  }
}
