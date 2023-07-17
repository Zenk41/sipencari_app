import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sipencari_app/models/missing/discussion_model.dart';
import 'package:sipencari_app/page/detail/missing_detail.dart';
import 'package:sipencari_app/page/main_page/edit_missing.dart';
import 'package:sipencari_app/service/providers/discussion/discussion_provider.dart';
import 'package:sipencari_app/service/providers/location_provider.dart';
import 'package:sipencari_app/service/providers/profile/profile_provider.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/util/category.dart';
import 'package:sipencari_app/util/finite_state.dart';
import 'package:sipencari_app/widgets/alert.dart';
import 'package:sipencari_app/widgets/search_field.dart';

class MyMissingPage extends StatefulWidget {
  const MyMissingPage({super.key});

  @override
  State<MyMissingPage> createState() => _MyMissingPageState();
}

class _MyMissingPageState extends State<MyMissingPage> {
  int selectedIndex = 0;
  late PageController _pageController;
  List<DiscussionData> _foundMyDis = [];
  String selectedCategory = 'all';
  String selectedStatus = 'all';

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);

    _initializeData();

    super.initState();
  }

  Future<void> _initializeData() async {
    final _providerDiscussion =
        Provider.of<DiscussionProvider>(context, listen: false);
    await _providerDiscussion.fetchMyDiscussion(context);

    _foundMyDis = _providerDiscussion.myDiscussion!.data!.toList();

    final _providerProfile =
        Provider.of<ProfileProvider>(context, listen: false);
    _providerProfile.fetchProfil(context);
  }

  void _runMyFilter(String eKeyword) {
    final _providerDiscussion =
        Provider.of<DiscussionProvider>(context, listen: false);
    List<DiscussionData> result =
        _providerDiscussion.myDiscussion!.data!.toList();

    if (eKeyword.isNotEmpty) {
      result = result
          .where((discussion) =>
              discussion.title
                  .toString()
                  .toLowerCase()
                  .contains(eKeyword.toLowerCase()) ||
              discussion.content
                  .toString()
                  .toLowerCase()
                  .contains(eKeyword.toLowerCase()) ||
              (discussion.discussionLocation?.locationName
                      ?.toString()
                      .toLowerCase()
                      .contains(eKeyword.toLowerCase()) ??
                  false))
          .toList();
    }

    if (selectedCategory != 'all') {
      result = result
          .where((discussion) =>
              discussion.category.toString().toLowerCase() ==
              getCategoryTranslations(selectedCategory))
          .toList();
    }

    if (selectedStatus != 'all') {
      result = result
          .where((discussion) =>
              discussion.status.toString().toLowerCase() ==
              getStatusTranslations(selectedStatus))
          .toList();
    }

    setState(() {
      _foundMyDis = result;
      print("Filtered discussions: ${_foundMyDis.toList()}");
    });
  }

  String getCategoryTranslations(String category) {
    switch (category) {
      case 'semua':
        return '';
      case 'orang hilang':
        return 'human';
      case 'barang hilang':
        return 'goods';
      case 'peliharaan hilang':
        return 'pet';
      default:
        return '';
    }
  }

  String getStatusTranslations(String status) {
    switch (status) {
      case 'semua':
        return '';
      case 'dicari':
        return 'notfound';
      case 'ditemukan':
        return 'found';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightQ = MediaQuery.of(context).size.height;
    double widthQ = MediaQuery.of(context).size.width;

    PopupMenuItem<String> buildFilterMenuItem(String value, String text) {
      return PopupMenuItem<String>(
        value: value,
        child: Text(text),
      );
    }

    Future showAlertDialogDelete(
        final String label,
        final Color color,
        final String content,
        final String label2,
        final String picture,
        String discussionID) {
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
              onClicked: () {
                final _providerDiscussion =
                    Provider.of<DiscussionProvider>(context, listen: false);
                _providerDiscussion
                    .delDiscussion(context, discussionID)
                    .whenComplete(() {
                  _providerDiscussion.fetchMyDiscussion(context).whenComplete(
                      () => _foundMyDis =
                          _providerDiscussion.myDiscussion!.data!.toList());
                }).whenComplete(() => Navigator.pop(context));
              },
            );
          });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: SearchField(
                          onChange: (value) {
                            setState(() {
                              _runMyFilter(value);
                              print("this is the value we search : ${value}");
                            });
                          },
                          icon: FluentIcons.search_28_regular,
                          hint: "Cari Kehilanganmu",
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          final _providerDiscussion =
                              Provider.of<DiscussionProvider>(context,
                                  listen: false);
                          _providerDiscussion.fetchMyDiscussion(context);
                          _foundMyDis =
                              _providerDiscussion.myDiscussion!.data!.toList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                            _runMyFilter('');
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'all',
                            child: Text('Semua kategori'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'orang hilang',
                            child: Text('Orang Hilang'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'barang hilang',
                            child: Text('Barang Hilang'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'peliharaan hilang',
                            child: Text('Peliharaan Hilang'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      flex: 1,
                      child: DropdownButton<String>(
                        value: selectedStatus,
                        onChanged: (newValue) {
                          setState(() {
                            selectedStatus = newValue!;
                            _runMyFilter('');
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'all',
                            child: Text('Semua status'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'dicari',
                            child: Text('Dicari'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'ditemukan',
                            child: Text('Ditemukan'),
                          ),
                          // Add more dropdown items for each status option
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Consumer3<DiscussionProvider, ProfileProvider, LocationProvider>(
          builder: (context, value, value2, value3, child) {
            switch (value.myState2) {
              case MyState.loading:
                return Center(child: CircularProgressIndicator());
              case MyState.loaded:
                if (value.myDiscussion?.data?.isEmpty ?? false) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return _foundMyDis.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: _foundMyDis.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                MissingDetail(
                                                  missingID: value.myDiscussion!
                                                      .data![index].discussionId
                                                      .toString(),
                                                ))));
                                  },
                                  child: Container(
                                    height: 480,
                                    color: whiteColor,
                                    child: Column(
                                      children: [
                                        Container(
                                          color: primaryColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    child: Container(
                                                        color: diffColor,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          (NumberFormat.compactCurrency(
                                                                          decimalDigits:
                                                                              2,
                                                                          symbol:
                                                                              '',
                                                                          locale:
                                                                              'id_IN')
                                                                      .format(Geolocator.distanceBetween(
                                                                              value3.initPosition!.latitude,
                                                                              value3.initPosition!.longitude,
                                                                              _foundMyDis[index].discussionLocation!.lat!.toDouble(),
                                                                              _foundMyDis[index].discussionLocation!.lng!.toDouble()) /
                                                                          1000))
                                                                  .toString() +
                                                              " KM",
                                                          style: smallTextStyle
                                                              .copyWith(
                                                                  fontSize: 10,
                                                                  color:
                                                                      whiteColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ))),
                                                Container(
                                                  width: widthQ - 220,
                                                  child: Text(
                                                    _foundMyDis[index]
                                                        .title
                                                        .toString(),
                                                    style:
                                                        smallTextStyle.copyWith(
                                                            fontSize: 12,
                                                            color: whiteColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.fade,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  child: Container(
                                                    color: diffColor,
                                                    padding: EdgeInsets.all(5),
                                                    child: _foundMyDis[index]
                                                                .status ==
                                                            "NotFound"
                                                        ? Text(
                                                            "Dicari",
                                                            style:
                                                                smallTextStyle
                                                                    .copyWith(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        : Text(
                                                            "Ditemukan",
                                                            style:
                                                                smallTextStyle
                                                                    .copyWith(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                            height: 240,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                CarouselSlider(
                                                  items: _foundMyDis[index]
                                                      .discussionPictures!
                                                      .toList()
                                                      .map((e) => Container(
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: e.url
                                                                  .toString(),
                                                              fit: BoxFit.cover,
                                                            ),
                                                            // color: Colors.green,
                                                          ))
                                                      .toList(),
                                                  options: CarouselOptions(
                                                      autoPlay: true,
                                                      viewportFraction: 0.9,
                                                      enableInfiniteScroll:
                                                          false),
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  right: 10,
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    child: Text(
                                                      getCategoryTranslation(
                                                              _foundMyDis[index]
                                                                  .category!) +
                                                          " Hilang",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        Text(
                                          _foundMyDis[index]
                                              .discussionLocation!
                                              .locationName
                                              .toString(),
                                          style: smallTextStyle.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                right: 8, left: 8),
                                            height: 100,
                                            child: Text(
                                              _foundMyDis[index]
                                                  .content
                                                  .toString(),
                                              textAlign: TextAlign.justify,
                                              maxLines: 7,
                                              overflow: TextOverflow.ellipsis,
                                              style: smallTextStyle.copyWith(),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          color: diffColor,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 12.0, right: 12.0),
                                              child:
                                                  (value2.profil!.data!
                                                                  .userId ==
                                                              _foundMyDis[index]
                                                                  .userId) ||
                                                          (value2.profil!.data!
                                                                  .role ==
                                                              "Admin") ||
                                                          (value2.profil!.data!
                                                                  .role ==
                                                              "Superadmin")
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                              Row(
                                                                children: [
                                                                  IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        final _providerDiscussion = Provider.of<DiscussionProvider>(
                                                                            context,
                                                                            listen:
                                                                                false);
                                                                        _providerDiscussion
                                                                            .service
                                                                            .postLikeDiscussion(context,
                                                                                _foundMyDis[index].discussionId!)
                                                                            .whenComplete(() {
                                                                          Timer(
                                                                              Duration(seconds: 0),
                                                                              () {
                                                                            _providerDiscussion.fetchMyDiscussion(context).whenComplete(() {
                                                                              _foundMyDis = _providerDiscussion.myDiscussion!.data!.toList();
                                                                            });
                                                                          });
                                                                          if (_foundMyDis[index].iLike! ==
                                                                              false) {
                                                                            Fluttertoast.showToast(
                                                                              msg: "Menyukai postingan",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor: primaryColor,
                                                                              textColor: blackColor,
                                                                              fontSize: 16.0,
                                                                            );
                                                                          } else {
                                                                            Fluttertoast.showToast(
                                                                              msg: "Menghapus suka pada postingan",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor: primaryColor,
                                                                              textColor: blackColor,
                                                                              fontSize: 16.0,
                                                                            );
                                                                          }
                                                                        });
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        (_foundMyDis[index].iLike ==
                                                                                true)
                                                                            ? FluentIcons.heart_24_filled
                                                                            : FluentIcons.heart_24_regular,
                                                                        size:
                                                                            20,
                                                                        color:
                                                                            whiteColor,
                                                                      )),
                                                                  Text(
                                                                    _foundMyDis[
                                                                            index]
                                                                        .likeTotal
                                                                        .toString(),
                                                                    style: smallTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                whiteColor),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: ((context) => MissingDetail(
                                                                                    missingID: _foundMyDis[index].discussionId.toString(),
                                                                                  ))));
                                                                    },
                                                                    icon: Icon(
                                                                        FluentIcons
                                                                            .comment_24_regular,
                                                                        size:
                                                                            20),
                                                                    color:
                                                                        whiteColor,
                                                                  ),
                                                                  Text(
                                                                    _foundMyDis[
                                                                            index]
                                                                        .commmentTotal
                                                                        .toString(),
                                                                    style: smallTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                whiteColor),
                                                                  ),
                                                                ],
                                                              ),
                                                              PopupMenuButton<
                                                                  int>(
                                                                iconSize: 25,
                                                                icon: Icon(Icons
                                                                    .more_vert_rounded),
                                                                itemBuilder:
                                                                    (context) =>
                                                                        [
                                                                  PopupMenuItem(
                                                                      value: 1,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(FluentIcons
                                                                              .delete_16_filled),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                              "Hapus")
                                                                        ],
                                                                      )),
                                                                  PopupMenuItem(
                                                                      value: 2,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(FluentIcons
                                                                              .edit_16_filled),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                              "Ubah")
                                                                        ],
                                                                      )),
                                                                ],
                                                                offset: Offset(
                                                                    20, 50),
                                                                color:
                                                                    whiteColor,
                                                                elevation: 1,
                                                                onSelected:
                                                                    (value) async {
                                                                  if (value ==
                                                                      1) {
                                                                    showAlertDialogDelete(
                                                                        "Tidak",
                                                                        primaryColor,
                                                                        "Apakah kamu ingin menghapus postingan ini?",
                                                                        "Iya",
                                                                        "assets/small_logo.png",
                                                                        _foundMyDis[index]
                                                                            .discussionId
                                                                            .toString());
                                                                  } else if (value ==
                                                                      2) {
                                                                    await Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: ((context) => EditMissingPage(
                                                                                  missingDetail: _foundMyDis[index],
                                                                                )))).whenComplete(() {
                                                                      final _providerDiscussion = Provider.of<
                                                                              DiscussionProvider>(
                                                                          context,
                                                                          listen:
                                                                              false);
                                                                      _providerDiscussion
                                                                          .fetchMyDiscussion(
                                                                              context);
                                                                      _foundMyDis = _providerDiscussion
                                                                          .myDiscussion!
                                                                          .data!
                                                                          .toList();
                                                                    });
                                                                  }
                                                                },
                                                              )
                                                            ])
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                              Row(
                                                                children: [
                                                                  IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        final _providerDiscussion = Provider.of<DiscussionProvider>(
                                                                            context,
                                                                            listen:
                                                                                false);
                                                                        await _providerDiscussion
                                                                            .service
                                                                            .postLikeDiscussion(context,
                                                                                _foundMyDis[index].discussionId!)
                                                                            .whenComplete(() {
                                                                          Timer(
                                                                              Duration(),
                                                                              () {
                                                                            _providerDiscussion.fetchMyDiscussion(context).whenComplete(() {
                                                                              _foundMyDis = _providerDiscussion.myDiscussion!.data!.toList();
                                                                            });
                                                                          });
                                                                        });
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        (_foundMyDis[index].iLike ==
                                                                                true)
                                                                            ? FluentIcons.heart_24_filled
                                                                            : FluentIcons.heart_24_regular,
                                                                        size:
                                                                            20,
                                                                        color:
                                                                            whiteColor,
                                                                      )),
                                                                  Text(
                                                                    _foundMyDis[
                                                                            index]
                                                                        .likeTotal
                                                                        .toString(),
                                                                    style: smallTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                whiteColor),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: ((context) => MissingDetail(
                                                                                    missingID: _foundMyDis[index].discussionId.toString(),
                                                                                  ))));
                                                                    },
                                                                    icon: Icon(
                                                                        FluentIcons
                                                                            .comment_24_regular,
                                                                        size:
                                                                            20),
                                                                    color:
                                                                        whiteColor,
                                                                  ),
                                                                  Text(
                                                                      _foundMyDis[
                                                                              index]
                                                                          .commmentTotal
                                                                          .toString(),
                                                                      style: smallTextStyle.copyWith(
                                                                          color:
                                                                              whiteColor)),
                                                                ],
                                                              ),
                                                              Container(
                                                                width: 45,
                                                              )
                                                            ])),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                      : Center(child: Text("data tidak ditemukan"));
                }
              case MyState.failed:
                return Center(
                  child: Text("data tidak ditemukan"),
                );
              default:
                return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
