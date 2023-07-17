import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sipencari_app/models/comment/data_comment_model.dart';
import 'package:sipencari_app/models/missing/discussion_model.dart';
import 'package:sipencari_app/page/detail/add_comment.dart';
import 'package:sipencari_app/page/detail/edit_comment.dart';
import 'package:sipencari_app/page/detail/full_image.dart';
import 'package:sipencari_app/page/main_page/edit_missing.dart';
import 'package:sipencari_app/service/providers/comment/comment_provider.dart';
import 'package:sipencari_app/service/providers/discussion/discussion_provider.dart';
import 'package:sipencari_app/service/providers/location_provider.dart';
import 'package:sipencari_app/service/providers/profile/profile_provider.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/util/category.dart';
import 'package:sipencari_app/util/finite_state.dart';
import 'package:sipencari_app/widgets/alert.dart';
import 'package:timeago/timeago.dart' as timeago;

class MissingDetail extends StatefulWidget {
  final String missingID;

  const MissingDetail({super.key, required this.missingID});

  @override
  State<MissingDetail> createState() => _MissingDetailState();
}

class _MissingDetailState extends State<MissingDetail> {
  Set<Marker> _markers = Set();
  late PageController _pageController;
  int currentPost = 0;
  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
    Future.delayed(Duration.zero, () {
      timeago.setLocaleMessages('id', timeago.IdMessages());
      final _providerLocation =
          Provider.of<LocationProvider>(context, listen: false);
      _providerLocation.initUserPosition(context);
      final _providerdiscussion =
          Provider.of<DiscussionProvider>(context, listen: false);
      _markers = _providerdiscussion.marker;
      final _providerComment =
          Provider.of<CommentProvider>(context, listen: false);
      _markers.remove(_markers.where(
        (marker) => marker.markerId.value == "markingmissing",
      ));

      _providerdiscussion
          .fetchOneDiscussion(
            context,
            widget.missingID,
          )
          .whenComplete(
              () => _providerComment.fetchComments(context, widget.missingID));

      initMarker();
    });

    super.initState();
  }

  void initMarker() async {
    _markers.removeAll(_markers.where(
      (marker) => marker.markerId.value == "markingmissing",
    ));
    final _providerLocaiton =
        Provider.of<LocationProvider>(context, listen: false);
    _providerLocaiton.initUserPosition(context);
    final _providerDiscussoin =
        Provider.of<DiscussionProvider>(context, listen: false);
    _providerDiscussoin.fetchOneDiscussion(
      context,
      widget.missingID,
    );
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

    Future showAlertDialogDeleteDiscussion(
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
                  _providerDiscussion.fetchDiscussion("1000", "0", context);
                  _providerDiscussion.fetchMyDiscussion(context);
                  Navigator.pop(context);
                }).whenComplete(() => Navigator.pop(context));
              },
            );
          });
    }

    Future showAlertDialogDelete(
        final String label,
        final Color color,
        final String content,
        final String label2,
        final String picture,
        String commentID) {
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
                final _providerComment =
                    Provider.of<CommentProvider>(context, listen: false);
                final _providerdiscussion =
                    Provider.of<DiscussionProvider>(context, listen: false);
                _providerComment
                    .delComment(context, commentID)
                    .whenComplete(() {
                  _providerdiscussion
                      .fetchOneDiscussion(
                        context,
                        widget.missingID,
                      )
                      .whenComplete(() => _providerComment.fetchComments(
                          context, widget.missingID));
                }).whenComplete(() => Navigator.pop(context));
              },
            );
          });
    }

    Future<void> _handleEditComment(
        BuildContext context, CommentData commentData) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditCommentPage(
            discussionID: commentData.discussionId.toString(),
            commentID: commentData.commentId.toString(),
            message: commentData.message.toString(),
          ),
        ),
      );

      final _providerComment =
          Provider.of<CommentProvider>(context, listen: false);
      _providerComment.fetchComments(context, widget.missingID);
    }

    Future<void> _handleEditMissing(
        BuildContext context, DiscussionData missingData) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditMissingPage(
            missingDetail: missingData,
          ),
        ),
      );

      final _providerdiscussion =
          Provider.of<DiscussionProvider>(context, listen: false);
      final _providerComment =
          Provider.of<CommentProvider>(context, listen: false);
      _providerdiscussion
          .fetchOneDiscussion(
            context,
            widget.missingID,
          )
          .whenComplete(
              () => _providerComment.fetchComments(context, widget.missingID));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  Text(
                    "DETAIL KEHILANGAN",
                    style: mediumTextStyle,
                  ),
                  IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      final _providerdiscussion =
                          Provider.of<DiscussionProvider>(context,
                              listen: false);
                      final _providerComment =
                          Provider.of<CommentProvider>(context, listen: false);
                      _providerdiscussion
                          .fetchOneDiscussion(
                            context,
                            widget.missingID,
                          )
                          .whenComplete(() => _providerComment.fetchComments(
                              context, widget.missingID));
                    },
                  )
                ],
              ),
            ),
          )),
      body: Consumer3<DiscussionProvider, LocationProvider, ProfileProvider>(
          builder: ((context, value, value2, value3, child) {
        switch (value.myState) {
          case MyState.loading:
            return Center(
              child: CircularProgressIndicator(),
            );
          case MyState.loaded:
            if (value.discussionDetail!.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return SizedBox(
                height: heightQ,
                width: widthQ,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 140,
                        child: Consumer2<LocationProvider, DiscussionProvider>(
                          builder: (context, value, value2, child) {
                            switch (value.myState) {
                              case MyState.loading:
                                return Center(
                                    child: CircularProgressIndicator());
                              case MyState.loaded:
                                if (value.ltdLng == null) {
                                  return GoogleMap(
                                    onMapCreated: (controller) {
                                      controller.showMarkerInfoWindow(
                                          MarkerId(widget.missingID));
                                    },
                                    myLocationEnabled: true,
                                    mapType: MapType.normal,
                                    markers: Set<Marker>.of(_markers),
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                            value2.discussionDetail!.data!
                                                .discussionLocation!.lat!
                                                .toDouble(),
                                            value2.discussionDetail!.data!
                                                .discussionLocation!.lng!
                                                .toDouble()),
                                        zoom: 11),
                                  );
                                } else {
                                  return GoogleMap(
                                    onMapCreated: (controller) {
                                      controller.showMarkerInfoWindow(
                                          MarkerId(widget.missingID));
                                    },
                                    myLocationEnabled: false,
                                    mapType: MapType.normal,
                                    markers: Set<Marker>.of(_markers),
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                            value2.discussionDetail!.data!
                                                .discussionLocation!.lat!
                                                .toDouble(),
                                            value2.discussionDetail!.data!
                                                .discussionLocation!.lng!
                                                .toDouble()),
                                        zoom: 14),
                                  );
                                }
                              case MyState.failed:
                                return Center(
                                  child: Text("cannot load map"),
                                );
                              default:
                                return Center(
                                    child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                      SelectableText(
                        value.discussionDetail!.data!.discussionLocation!
                            .locationName
                            .toString(),
                        style: smallTextStyle.copyWith(
                            fontSize: 10, fontWeight: FontWeight.bold),
                        enableInteractiveSelection: true,
                        toolbarOptions:
                            ToolbarOptions(selectAll: true, copy: true),
                        showCursor: true,
                        cursorWidth: 2,
                        cursorColor: Colors.black,
                        cursorRadius: Radius.circular(5),
                      ),
                      Container(
                        color: primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: Container(
                                      color: diffColor,
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        (NumberFormat.compactCurrency(
                                                        decimalDigits: 2,
                                                        symbol: '',
                                                        locale: 'id_IN')
                                                    .format(Geolocator.distanceBetween(
                                                            value2.initPosition!
                                                                .latitude,
                                                            value2.initPosition!
                                                                .longitude,
                                                            value
                                                                .discussionDetail!
                                                                .data!
                                                                .discussionLocation!
                                                                .lat!
                                                                .toDouble(),
                                                            value
                                                                .discussionDetail!
                                                                .data!
                                                                .discussionLocation!
                                                                .lng!
                                                                .toDouble()) /
                                                        1000))
                                                .toString() +
                                            " KM",
                                        style: smallTextStyle.copyWith(
                                            fontSize: 10,
                                            color: whiteColor,
                                            fontWeight: FontWeight.bold),
                                      ))),
                              Flexible(
                                child: Container(
                                  width: widthQ - 220,
                                  child: Text(
                                    value.discussionDetail!.data!.title
                                        .toString(),
                                    style: smallTextStyle.copyWith(
                                        fontSize: 12,
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 4,
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: Container(
                                  color: diffColor,
                                  padding: EdgeInsets.all(5),
                                  child: value.discussionDetail!.data!.status ==
                                          "NotFound"
                                      ? Text(
                                          "Dicari",
                                          style: smallTextStyle.copyWith(
                                            fontSize: 10,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          "Ditemukan",
                                          style: smallTextStyle.copyWith(
                                            fontSize: 10,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    color: grey3Color,
                                    height: 40,
                                    width: 40,
                                    child: CachedNetworkImage(
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                              Icons.person,
                                              color: whiteColor,
                                            ),
                                        progressIndicatorBuilder: (context, url,
                                                progress) =>
                                            Center(
                                              child: CircularProgressIndicator(
                                                value: progress.progress,
                                              ),
                                            ),
                                        imageUrl: value.discussionDetail!.data!
                                            .user!.picture
                                            .toString()),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  value.discussionDetail!.data!.user!.name
                                      .toString(),
                                  style: mediumTextStyle,
                                )
                              ],
                            )),
                            Text(timeago.format(
                                value.discussionDetail!.data!.createdAt!,
                                locale: 'id')),
                          ],
                        ),
                      ),
                      Container(
                        height: 330,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CarouselSlider(
                                  items: value.discussionDetail!.data!
                                      .discussionPictures!
                                      .toList()
                                      .map((e) {
                                    return Builder(
                                        builder: (BuildContext context) {
                                      return Container(
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              child: CachedNetworkImage(
                                                height: 300,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(
                                                  Icons.error_outline_rounded,
                                                  color: whiteColor,
                                                ),
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: progress.progress,
                                                  ),
                                                ),
                                                imageUrl: e.url.toString(),
                                                fit: BoxFit.fitHeight,
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullImage(
                                                      title:
                                                          "Gambar di layar penuh",
                                                      imageUrl:
                                                          e.url.toString(),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                                  }).toList(),
                                  options: CarouselOptions(
                                    height: 300,
                                    viewportFraction: 1,
                                    disableCenter: true,
                                    autoPlay: true,
                                    enableInfiniteScroll: false,
                                    onPageChanged: (indexs, reason) {
                                      setState(() {
                                        currentPost = indexs;
                                      });
                                    },
                                    enlargeCenterPage: true,
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    color: Colors.black.withOpacity(0.5),
                                    child: Text(
                                      getCategoryTranslation(value
                                              .discussionDetail!
                                              .data!
                                              .category!) +
                                          " Hilang",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: value
                                  .discussionDetail!.data!.discussionPictures!
                                  .map((e) {
                                int index = value
                                    .discussionDetail!.data!.discussionPictures!
                                    .indexOf(e);
                                return Container(
                                  width: 8,
                                  height: 8,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentPost == index
                                        ? Color.fromRGBO(0, 0, 0, 0.9)
                                        : Color.fromRGBO(0, 0, 0, 0.4),
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8, left: 8),
                        child: SelectableText(
                          value.discussionDetail!.data!.content.toString(),
                          textAlign: TextAlign.justify,
                          style: smallTextStyle.copyWith(),
                          enableInteractiveSelection: true,
                          toolbarOptions:
                              ToolbarOptions(selectAll: true, copy: true),
                          showCursor: true,
                          cursorWidth: 2,
                          cursorColor: Colors.black,
                          cursorRadius: Radius.circular(5),
                        ),
                      ),
                      Container(
                        height: 40,
                        color: diffColor,
                        child: (value3.profil!.data!.userId ==
                                    value.discussionDetail!.data!.userId) ||
                                (value3.profil!.data!.role == "Admin") ||
                                (value3.profil!.data!.role == "Superadmin")
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              final _providerDiscussion =
                                                  Provider.of<
                                                          DiscussionProvider>(
                                                      context,
                                                      listen: false);
                                              _providerDiscussion.service
                                                  .postLikeDiscussion(
                                                      context,
                                                      value.discussionDetail!
                                                          .data!.discussionId!)
                                                  .whenComplete(() {
                                                Timer(Duration(seconds: 0), () {
                                                  _providerDiscussion
                                                      .fetchOneDiscussion(
                                                    context,
                                                    widget.missingID,
                                                  );
                                                });
                                                if (value.discussionDetail!
                                                        .data!.iLike! ==
                                                    false) {
                                                  Fluttertoast.showToast(
                                                    msg: "Menyukai postingan",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        primaryColor,
                                                    textColor: blackColor,
                                                    fontSize: 16.0,
                                                  );
                                                } else {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Menghapus suka pada postingan",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        primaryColor,
                                                    textColor: blackColor,
                                                    fontSize: 16.0,
                                                  );
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              (value.discussionDetail!.data!
                                                          .iLike! ==
                                                      true)
                                                  ? FluentIcons.heart_24_filled
                                                  : FluentIcons
                                                      .heart_24_regular,
                                              size: 20,
                                              color: whiteColor,
                                            )),
                                        Text(
                                          value
                                              .discussionDetail!.data!.likeTotal
                                              .toString(),
                                          style: smallTextStyle.copyWith(
                                              color: whiteColor),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  AddCommentPage(
                                                discussionID: value
                                                    .discussionDetail!
                                                    .data!
                                                    .discussionId
                                                    .toString(),
                                              ),
                                            ));

                                            final _providerDiscussion =
                                                Provider.of<DiscussionProvider>(
                                                    context,
                                                    listen: false);
                                            final _providerComment =
                                                Provider.of<CommentProvider>(
                                                    context,
                                                    listen: false);

                                            await _providerDiscussion
                                                .fetchOneDiscussion(
                                                    context, widget.missingID);
                                            await _providerComment
                                                .fetchComments(
                                                    context, widget.missingID);
                                          },
                                          icon: Icon(
                                              FluentIcons.comment_24_regular,
                                              size: 20),
                                          color: whiteColor,
                                        ),
                                        Text(
                                          value.discussionDetail!.data!
                                              .commmentTotal
                                              .toString(),
                                          style: smallTextStyle.copyWith(
                                              color: whiteColor),
                                        ),
                                      ],
                                    ),
                                    PopupMenuButton<int>(
                                      iconSize: 25,
                                      icon: Icon(Icons.more_vert_rounded),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: Row(
                                              children: [
                                                Icon(FluentIcons
                                                    .delete_16_filled),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text("Hapus")
                                              ],
                                            )),
                                        PopupMenuItem(
                                            value: 2,
                                            child: Row(
                                              children: [
                                                Icon(
                                                    FluentIcons.edit_16_filled),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text("Ubah")
                                              ],
                                            )),
                                      ],
                                      offset: Offset(20, 50),
                                      color: whiteColor,
                                      elevation: 1,
                                      onSelected: (values) async {
                                        if (values == 1) {
                                          showAlertDialogDeleteDiscussion(
                                              "Tidak",
                                              primaryColor,
                                              "Apakah kamu ingin menghapus postingan ini?",
                                              "Iya",
                                              "assets/small_logo.png",
                                              value.discussionDetail!.data!
                                                  .discussionId
                                                  .toString());
                                        } else if (values == 2) {
                                          await _handleEditMissing(context,
                                              value.discussionDetail!.data!);
                                        }
                                      },
                                    ),
                                  ])
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              final _providerDiscussion =
                                                  Provider.of<
                                                          DiscussionProvider>(
                                                      context,
                                                      listen: false);
                                              _providerDiscussion.service
                                                  .postLikeDiscussion(
                                                      context,
                                                      value.discussionDetail!
                                                          .data!.discussionId!)
                                                  .whenComplete(() {
                                                Timer(Duration(seconds: 0), () {
                                                  _providerDiscussion
                                                      .fetchOneDiscussion(
                                                    context,
                                                    widget.missingID,
                                                  );
                                                });
                                                if (value.discussionDetail!
                                                        .data!.iLike! ==
                                                    false) {
                                                  Fluttertoast.showToast(
                                                    msg: "Menyukai postingan",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        primaryColor,
                                                    textColor: blackColor,
                                                    fontSize: 16.0,
                                                  );
                                                } else {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Menghapus suka pada postingan",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        primaryColor,
                                                    textColor: blackColor,
                                                    fontSize: 16.0,
                                                  );
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              (value.discussionDetail!.data!
                                                          .iLike! ==
                                                      true)
                                                  ? FluentIcons.heart_24_filled
                                                  : FluentIcons
                                                      .heart_24_regular,
                                              size: 20,
                                              color: whiteColor,
                                            )),
                                        Text(
                                          value
                                              .discussionDetail!.data!.likeTotal
                                              .toString(),
                                          style: smallTextStyle.copyWith(
                                              color: whiteColor),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                              FluentIcons.comment_24_regular,
                                              size: 20),
                                          color: whiteColor,
                                        ),
                                        Text(
                                            value.discussionDetail!.data!
                                                .commmentTotal
                                                .toString(),
                                            style: smallTextStyle.copyWith(
                                                color: whiteColor)),
                                      ],
                                    ),
                                    Container(
                                      width: 45,
                                    )
                                  ]),
                      ),
                      Consumer<CommentProvider>(
                          builder: ((context, value, child) {
                        switch (value.myState) {
                          case MyState.loading:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          case MyState.loaded:
                            if (value.commentInList!.data == null) {
                              return Center(
                                child: Text("Tidak ada komentar"),
                              );
                            } else {
                              return value.commentInList!.data!.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          value.commentInList!.data!.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                            padding: EdgeInsets.all(2),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              child: Container(
                                                                color:
                                                                    grey3Color,
                                                                height: 35,
                                                                width: 35,
                                                                child:
                                                                    CachedNetworkImage(
                                                                  errorWidget:
                                                                      (context,
                                                                              url,
                                                                              error) =>
                                                                          Icon(
                                                                    Icons
                                                                        .person,
                                                                    color:
                                                                        whiteColor,
                                                                  ),
                                                                  progressIndicatorBuilder:
                                                                      (context,
                                                                              url,
                                                                              progress) =>
                                                                          Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      value: progress
                                                                          .progress,
                                                                    ),
                                                                  ),
                                                                  imageUrl: value
                                                                          .commentInList
                                                                          ?.data?[
                                                                              index]
                                                                          .user
                                                                          ?.picture
                                                                          ?.toString() ??
                                                                      '',
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              value
                                                                      .commentInList
                                                                      ?.data?[
                                                                          index]
                                                                      .user
                                                                      ?.name
                                                                      ?.toString() ??
                                                                  '',
                                                              style: mediumTextStyle
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        timeago.format(
                                                          value
                                                                  .commentInList
                                                                  ?.data?[index]
                                                                  .createdAt ??
                                                              DateTime.now(),
                                                          locale: 'id',
                                                        ),
                                                        style: smallTextStyle,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: (value
                                                              .commentInList
                                                              ?.data?[index]
                                                              .commentPictures
                                                              ?.isNotEmpty ??
                                                          false)
                                                      ? 250
                                                      : 5,
                                                  child: (value
                                                              .commentInList
                                                              ?.data?[index]
                                                              .commentPictures
                                                              ?.isNotEmpty ??
                                                          false)
                                                      ? Column(
                                                          children: [
                                                            CarouselSlider(
                                                              items: value
                                                                      .commentInList
                                                                      ?.data?[
                                                                          index]
                                                                      .commentPictures
                                                                      ?.toList()
                                                                      .map((e) {
                                                                    return Builder(
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return Column(
                                                                          children: [
                                                                            GestureDetector(
                                                                              child: CachedNetworkImage(
                                                                                height: 130,
                                                                                errorWidget: (context, url, error) => Icon(
                                                                                  Icons.error_outline_rounded,
                                                                                  color: whiteColor,
                                                                                ),
                                                                                progressIndicatorBuilder: (context, url, progress) => Center(
                                                                                  child: CircularProgressIndicator(
                                                                                    value: progress.progress,
                                                                                  ),
                                                                                ),
                                                                                imageUrl: e.url?.toString() ?? '',
                                                                                fit: BoxFit.fill,
                                                                              ),
                                                                              onTap: () {
                                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => FullImage(title: "Gambar di layar penuh", imageUrl: e.url.toString())));
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }).toList() ??
                                                                  [],
                                                              options:
                                                                  CarouselOptions(
                                                                height: 150,
                                                                viewportFraction:
                                                                    1,
                                                                disableCenter:
                                                                    true,
                                                                autoPlay: false,
                                                                enableInfiniteScroll:
                                                                    false,
                                                                onPageChanged:
                                                                    (indexs,
                                                                        reason) {
                                                                  setState(() {
                                                                    value.currentPosts[
                                                                            index] =
                                                                        indexs;
                                                                  });
                                                                },
                                                                enlargeCenterPage:
                                                                    true,
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: value
                                                                      .commentInList
                                                                      ?.data?[
                                                                          index]
                                                                      .commentPictures
                                                                      ?.map(
                                                                          (e) {
                                                                    int indexs = value
                                                                            .commentInList
                                                                            ?.data?[index]
                                                                            .commentPictures
                                                                            ?.indexOf(e) ??
                                                                        0;
                                                                    return Container(
                                                                      width: 8,
                                                                      height: 8,
                                                                      margin: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              10,
                                                                          horizontal:
                                                                              2),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: value.currentPosts[index] ==
                                                                                indexs
                                                                            ? Color.fromRGBO(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0.9)
                                                                            : Color.fromRGBO(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0.4),
                                                                      ),
                                                                    );
                                                                  }).toList() ??
                                                                  [],
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox(
                                                          height: 5,
                                                        ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8, left: 8),
                                                  child: SelectableText(
                                                    value.commentInList!
                                                        .data![index].message
                                                        .toString(),
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: smallTextStyle
                                                        .copyWith(),
                                                    enableInteractiveSelection:
                                                        true,
                                                    toolbarOptions:
                                                        ToolbarOptions(
                                                            selectAll: true,
                                                            copy: true),
                                                    showCursor: true,
                                                    cursorWidth: 2,
                                                    cursorColor: Colors.black,
                                                    cursorRadius:
                                                        Radius.circular(5),
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  color: diffColor,
                                                  child: (value3.profil!.data!
                                                                  .userId ==
                                                              value
                                                                  .commentInList!
                                                                  .data![index]
                                                                  .userId) ||
                                                          (value3.profil!.data!
                                                                  .role ==
                                                              "Admin") ||
                                                          (value3.profil!.data!
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
                                                                        final _providerComment = Provider.of<CommentProvider>(
                                                                            context,
                                                                            listen:
                                                                                false);

                                                                        _providerComment
                                                                            .service
                                                                            .postLikeComment(context,
                                                                                value.commentInList!.data![index].commentId!)
                                                                            .whenComplete(() {
                                                                          Timer(
                                                                              Duration(seconds: 0),
                                                                              () {
                                                                            _providerComment.fetchComments(
                                                                              context,
                                                                              widget.missingID,
                                                                            );
                                                                            if (value.commentInList!.data![index].isLike! ==
                                                                                false) {
                                                                              Fluttertoast.showToast(
                                                                                msg: "Menyukai komentar",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.CENTER,
                                                                                timeInSecForIosWeb: 1,
                                                                                backgroundColor: primaryColor,
                                                                                textColor: blackColor,
                                                                                fontSize: 16.0,
                                                                              );
                                                                            } else {
                                                                              Fluttertoast.showToast(
                                                                                msg: "Menghapus suka pada komentar",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.CENTER,
                                                                                timeInSecForIosWeb: 1,
                                                                                backgroundColor: primaryColor,
                                                                                textColor: blackColor,
                                                                                fontSize: 16.0,
                                                                              );
                                                                            }
                                                                          });
                                                                        });
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        (value.commentInList!.data![index].isLike! ==
                                                                                true)
                                                                            ? FluentIcons.heart_24_filled
                                                                            : FluentIcons.heart_24_regular,
                                                                        size:
                                                                            20,
                                                                        color:
                                                                            whiteColor,
                                                                      )),
                                                                  Text(
                                                                    value
                                                                        .commentInList!
                                                                        .data![
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
                                                                        () async {
                                                                      final _providerComment = Provider.of<
                                                                              CommentProvider>(
                                                                          context,
                                                                          listen:
                                                                              false);

                                                                      _providerComment
                                                                          .service
                                                                          .postReactionComment(
                                                                              context,
                                                                              value.commentInList!.data![index].commentId!,
                                                                              "Yes")
                                                                          .whenComplete(() {
                                                                        Timer(
                                                                            Duration(seconds: 0),
                                                                            () {
                                                                          _providerComment
                                                                              .fetchComments(
                                                                            context,
                                                                            widget.missingID,
                                                                          );
                                                                          if (value.commentInList!.data![index].isHelpfulYes ==
                                                                              false) {
                                                                            Fluttertoast.showToast(
                                                                              msg: "Memberi reaksi membantu",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor: primaryColor,
                                                                              textColor: blackColor,
                                                                              fontSize: 16.0,
                                                                            );
                                                                          } else {
                                                                            Fluttertoast.showToast(
                                                                              msg: "Menghapus reaksi membantu",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor: primaryColor,
                                                                              textColor: blackColor,
                                                                              fontSize: 16.0,
                                                                            );
                                                                          }
                                                                        });
                                                                      });
                                                                    },
                                                                    icon: Icon(
                                                                      (value.commentInList!.data![index].isHelpfulYes ==
                                                                              true)
                                                                          ? FluentIcons
                                                                              .thumb_like_16_filled
                                                                          : FluentIcons
                                                                              .thumb_like_16_regular,
                                                                      size: 20,
                                                                    ),
                                                                    color:
                                                                        whiteColor,
                                                                  ),
                                                                  Text(
                                                                    value
                                                                        .commentInList!
                                                                        .data![
                                                                            index]
                                                                        .totalHelpfulYes
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
                                                                        () async {
                                                                      final _providerComment = Provider.of<
                                                                              CommentProvider>(
                                                                          context,
                                                                          listen:
                                                                              false);

                                                                      _providerComment
                                                                          .service
                                                                          .postReactionComment(
                                                                              context,
                                                                              value.commentInList!.data![index].commentId!,
                                                                              "No")
                                                                          .whenComplete(() {
                                                                        Timer(
                                                                            Duration(seconds: 0),
                                                                            () {
                                                                          _providerComment
                                                                              .fetchComments(
                                                                            context,
                                                                            widget.missingID,
                                                                          );
                                                                          if (value.commentInList!.data![index].isHelpfulNo ==
                                                                              false) {
                                                                            Fluttertoast.showToast(
                                                                              msg: "Memberi reaksi tidak membantu",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor: primaryColor,
                                                                              textColor: blackColor,
                                                                              fontSize: 16.0,
                                                                            );
                                                                          } else {
                                                                            Fluttertoast.showToast(
                                                                              msg: "Menghapus reaksi tidak membantu",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor: primaryColor,
                                                                              textColor: blackColor,
                                                                              fontSize: 16.0,
                                                                            );
                                                                          }
                                                                        });
                                                                      });
                                                                    },
                                                                    icon: Icon(
                                                                      (value.commentInList!.data![index].isHelpfulNo! ==
                                                                              true)
                                                                          ? FluentIcons
                                                                              .thumb_dislike_16_filled
                                                                          : FluentIcons
                                                                              .thumb_dislike_16_regular,
                                                                      size: 20,
                                                                    ),
                                                                    color:
                                                                        whiteColor,
                                                                  ),
                                                                  Text(
                                                                    (value.commentInList!.data![index].totalHelpfulNo !=
                                                                            0)
                                                                        ? "-" +
                                                                            value.commentInList!.data![index].totalHelpfulNo
                                                                                .toString()
                                                                        : value
                                                                            .commentInList!
                                                                            .data![index]
                                                                            .totalHelpfulNo
                                                                            .toString(),
                                                                    style: smallTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                whiteColor),
                                                                  ),
                                                                  PopupMenuButton<
                                                                      int>(
                                                                    iconSize:
                                                                        25,
                                                                    icon: Icon(Icons
                                                                        .more_vert_rounded),
                                                                    itemBuilder:
                                                                        (context) =>
                                                                            [
                                                                      PopupMenuItem(
                                                                          value:
                                                                              1,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(FluentIcons.delete_16_filled),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Text("Hapus")
                                                                            ],
                                                                          )),
                                                                      PopupMenuItem(
                                                                          value:
                                                                              2,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(FluentIcons.edit_16_filled),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Text("Ubah")
                                                                            ],
                                                                          )),
                                                                    ],
                                                                    offset:
                                                                        Offset(
                                                                            20,
                                                                            50),
                                                                    color:
                                                                        whiteColor,
                                                                    elevation:
                                                                        1,
                                                                    onSelected:
                                                                        (values) async {
                                                                      if (values ==
                                                                          1) {
                                                                        showAlertDialogDelete(
                                                                            "Tidak",
                                                                            primaryColor,
                                                                            "Apakah kamu ingin menghapus komentar ini?",
                                                                            "Iya",
                                                                            "assets/small_logo.png",
                                                                            value.commentInList!.data![index].commentId.toString());
                                                                      } else if (values ==
                                                                          2) {
                                                                        await _handleEditComment(
                                                                            context,
                                                                            value.commentInList!.data![index]);
                                                                      }
                                                                    },
                                                                  )
                                                                ],
                                                              ),
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
                                                                        final _providerComment = Provider.of<CommentProvider>(
                                                                            context,
                                                                            listen:
                                                                                false);

                                                                        _providerComment
                                                                            .service
                                                                            .postLikeComment(context,
                                                                                value.commentInList!.data![index].commentId!)
                                                                            .whenComplete(() {
                                                                          Timer(
                                                                              Duration(seconds: 0),
                                                                              () {
                                                                            _providerComment.fetchComments(
                                                                              context,
                                                                              widget.missingID,
                                                                            );
                                                                          });
                                                                          if (value.commentInList!.data![index].isLike! ==
                                                                              false) {
                                                                            Fluttertoast.showToast(
                                                                              msg: "Menyukai komentar",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor: primaryColor,
                                                                              textColor: blackColor,
                                                                              fontSize: 16.0,
                                                                            );
                                                                          } else {
                                                                            Fluttertoast.showToast(
                                                                              msg: "Menghapus suka pada komentar",
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
                                                                        (value.commentInList!.data![index].isLike! ==
                                                                                true)
                                                                            ? FluentIcons.heart_24_filled
                                                                            : FluentIcons.heart_24_regular,
                                                                        size:
                                                                            20,
                                                                        color:
                                                                            whiteColor,
                                                                      )),
                                                                  Text(
                                                                    value
                                                                        .commentInList!
                                                                        .data![
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
                                                                          () async {
                                                                        final _providerComment = Provider.of<CommentProvider>(
                                                                            context,
                                                                            listen:
                                                                                false);

                                                                        _providerComment
                                                                            .service
                                                                            .postReactionComment(
                                                                                context,
                                                                                value.commentInList!.data![index].commentId!,
                                                                                "Yes")
                                                                            .whenComplete(() {
                                                                          Timer(
                                                                              Duration(seconds: 0),
                                                                              () {
                                                                            _providerComment.fetchComments(
                                                                              context,
                                                                              widget.missingID,
                                                                            );
                                                                          });
                                                                          if (value.commentInList!.data![index].isHelpfulYes ==
                                                                              false) {
                                                                            Fluttertoast.showToast(
                                                                              msg: "Memberi reaksi membantu",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor: primaryColor,
                                                                              textColor: blackColor,
                                                                              fontSize: 16.0,
                                                                            );
                                                                          } else {
                                                                            Fluttertoast.showToast(
                                                                              msg: "Menghapus reaksi membantu",
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
                                                                        (value.commentInList!.data![index].isHelpfulYes ==
                                                                                true)
                                                                            ? FluentIcons.thumb_like_16_filled
                                                                            : FluentIcons.thumb_like_16_regular,
                                                                        size:
                                                                            20,
                                                                        color:
                                                                            whiteColor,
                                                                      )),
                                                                  Text(
                                                                    value
                                                                        .commentInList!
                                                                        .data![
                                                                            index]
                                                                        .totalHelpfulYes
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
                                                                        () async {
                                                                      final _providerComment = Provider.of<
                                                                              CommentProvider>(
                                                                          context,
                                                                          listen:
                                                                              false);

                                                                      _providerComment
                                                                          .service
                                                                          .postReactionComment(
                                                                              context,
                                                                              value.commentInList!.data![index].commentId!,
                                                                              "No")
                                                                          .whenComplete(() {
                                                                        Timer(
                                                                            Duration(seconds: 0),
                                                                            () {
                                                                          _providerComment
                                                                              .fetchComments(
                                                                            context,
                                                                            widget.missingID,
                                                                          );
                                                                        });
                                                                        if (value.commentInList!.data![index].isHelpfulNo ==
                                                                            false) {
                                                                          Fluttertoast
                                                                              .showToast(
                                                                            msg:
                                                                                "Memberi reaksi tidak membantu",
                                                                            toastLength:
                                                                                Toast.LENGTH_SHORT,
                                                                            gravity:
                                                                                ToastGravity.CENTER,
                                                                            timeInSecForIosWeb:
                                                                                1,
                                                                            backgroundColor:
                                                                                primaryColor,
                                                                            textColor:
                                                                                blackColor,
                                                                            fontSize:
                                                                                16.0,
                                                                          );
                                                                        } else {
                                                                          Fluttertoast
                                                                              .showToast(
                                                                            msg:
                                                                                "Menghapus reaksi tidak membantu",
                                                                            toastLength:
                                                                                Toast.LENGTH_SHORT,
                                                                            gravity:
                                                                                ToastGravity.CENTER,
                                                                            timeInSecForIosWeb:
                                                                                1,
                                                                            backgroundColor:
                                                                                primaryColor,
                                                                            textColor:
                                                                                blackColor,
                                                                            fontSize:
                                                                                16.0,
                                                                          );
                                                                        }
                                                                      });
                                                                    },
                                                                    icon: Icon(
                                                                      (value.commentInList!.data![index].isHelpfulNo! ==
                                                                              true)
                                                                          ? FluentIcons
                                                                              .thumb_dislike_16_filled
                                                                          : FluentIcons
                                                                              .thumb_dislike_16_regular,
                                                                      size: 20,
                                                                      color:
                                                                          whiteColor,
                                                                    ),
                                                                    color:
                                                                        whiteColor,
                                                                  ),
                                                                  Text(
                                                                      (value.commentInList!.data![index].totalHelpfulNo !=
                                                                              0)
                                                                          ? "-" +
                                                                              value.commentInList!.data![index].totalHelpfulNo
                                                                                  .toString()
                                                                          : value
                                                                              .commentInList!
                                                                              .data![
                                                                                  index]
                                                                              .totalHelpfulNo
                                                                              .toString(),
                                                                      style: smallTextStyle.copyWith(
                                                                          color:
                                                                              whiteColor)),
                                                                ],
                                                              ),
                                                              Container(
                                                                width: 45,
                                                              )
                                                            ]),
                                                ),
                                                SizedBox(
                                                  height: 50,
                                                )
                                              ],
                                            ));
                                      })
                                  : Center(
                                      child: Text("Tidak ada komentar"),
                                    );
                            }
                          case MyState.failed:
                            return Center(
                              child: Text("Tidak ada komentar"),
                            );
                          default:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                      })),
                    ],
                  ),
                ),
              );
            }
          case MyState.failed:
            return Center(
              child: Text("Discussion not found"),
            );
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      })),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddCommentPage(
              discussionID: widget.missingID,
            ),
          ));

          final _providerDiscussion =
              Provider.of<DiscussionProvider>(context, listen: false);
          final _providerComment =
              Provider.of<CommentProvider>(context, listen: false);

          await _providerDiscussion.fetchOneDiscussion(
              context, widget.missingID);
          await _providerComment.fetchComments(context, widget.missingID);
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add_comment,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
