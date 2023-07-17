import 'package:maps_launcher/maps_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sipencari_app/models/missing/discussion_model.dart';
import 'package:sipencari_app/page/auth/login_page.dart';
import 'package:sipencari_app/page/detail/full_image.dart';
import 'package:sipencari_app/page/detail/missing_detail.dart';
import 'package:sipencari_app/page/welcome_page/welcome_page.dart';
import 'package:sipencari_app/service/database/discussion/discussion_service.dart';
import 'package:sipencari_app/service/providers/comment/comment_provider.dart';
import 'package:sipencari_app/service/providers/location_provider.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/util/category.dart';
import 'package:sipencari_app/util/finite_state.dart';
import 'package:sipencari_app/util/image.dart';
import 'package:sipencari_app/view_model/auth/auth_view_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class DiscussionProvider extends ChangeNotifier {
  final DiscussionApi service = DiscussionApi();

  DiscussionResponse? discussion;
  DiscussionResponseNoPag? myDiscussion;
  DiscussionResponseOne? discussionDetail;
  DiscussionResponseOne? discussionOnMark;

  List<Marker> markerdis = [];
  Set<Marker> marker = {};
  Set<Marker> markerInMap = {};
  List<Marker> markerdisInMap = [];

  MyState myState = MyState.loading;
  MyState myState2 = MyState.loading;
  MyState mystate3 = MyState.loading;
  MyState stateInMark = MyState.loading;

  Future fetchDiscussion(String size, String page, BuildContext context) async {
    try {
      myState = MyState.loading;
      notifyListeners();

      discussion = await service.getDiscussionPublic(context, size, page);
      // check response
      if (discussion!.message == "invalid or expired jwt" ||
          discussion!.message == "missing or malformed jwt") {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ));
      }

      marker.removeAll(marker.where(
        (marker) => marker.markerId.value == "markingmissing",
      ));

      if (discussion!.data!.items != null &&
          discussion!.data!.items!.isNotEmpty) {
        final markericon = await getBitmapDescriptorFromAssetBytes(
            "assets/icons/marker.png", 50);
        for (var item = 0;
            item < discussion!.data!.items!.toList().length;
            item++) {
          final missingMarkers = Marker(
            markerId: MarkerId(
                discussion!.data!.items![item].discussionId.toString()),
            position: LatLng(
                discussion!.data!.items![item].discussionLocation!.lat!,
                discussion!.data!.items![item].discussionLocation!.lng!),
            infoWindow: InfoWindow(
                title: discussion!.data!.items![item].title
                    .toString()
                    .substring(0)),
            icon: markericon,
            onTap: () {
              final _providerComment =
                  Provider.of<CommentProvider>(context, listen: false);
              fetchOneDiscussion(context,
                      discussion!.data!.items![item].discussionId.toString())
                  .whenComplete(() {
                _providerComment.fetchComments(context,
                    discussion!.data!.items![item].discussionId.toString());
              });
              MissingDetail(
                  missingID:
                      discussion!.data!.items![item].discussionId.toString());
            },
          );

          final missingMarkersLargeMap = Marker(
            markerId: MarkerId(
              discussion!.data!.items![item].discussionId.toString(),
            ),
            position: LatLng(
              discussion!.data!.items![item].discussionLocation!.lat!,
              discussion!.data!.items![item].discussionLocation!.lng!,
            ),
            infoWindow: InfoWindow(
              title:
                  discussion!.data!.items![item].title.toString().substring(0),
            ),
            icon: markericon,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      discussion!.data!.items![item].title
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => MissingDetail(
                                                missingID: discussion!.data!
                                                    .items![item].discussionId
                                                    .toString(),
                                              )),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Detail',
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right,
                                          size: 30,
                                          color: primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Stack(
                                children: [
                                  Container(
                                    height: 120,
                                    child: CarouselSlider(
                                      items: discussion!.data!.items![item]
                                          .discussionPictures!
                                          .toList()
                                          .map(
                                            (e) => GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FullImage(
                                                                title:
                                                                    "Gambar di layar penuh",
                                                                imageUrl: e.url
                                                                    .toString())));
                                              },
                                              child: Container(
                                                child: CachedNetworkImage(
                                                  height: 120,
                                                  imageUrl: e.url.toString(),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      options: CarouselOptions(
                                        autoPlay: true,
                                        viewportFraction: 0.9,
                                        enableInfiniteScroll: false,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      color: Colors.black.withOpacity(0.5),
                                      child: Text(
                                        getCategoryTranslation(discussion!
                                                .data!.items![item].category!) +
                                            " Hilang",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                discussion!.data!.items![item]
                                    .discussionLocation!.locationName
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    timeago.format(
                                      discussion!.data!.items![item].createdAt!,
                                      locale: 'id',
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Consumer<LocationProvider>(
                                    builder: (context, value, child) {
                                      return Text(
                                        (NumberFormat.compactCurrency(
                                              decimalDigits: 2,
                                              symbol: '',
                                              locale: 'id_IN',
                                            ).format(
                                              Geolocator.distanceBetween(
                                                    value
                                                        .initPosition!.latitude,
                                                    value.initPosition!
                                                        .longitude,
                                                    discussion!
                                                        .data!
                                                        .items![item]
                                                        .discussionLocation!
                                                        .lat!
                                                        .toDouble(),
                                                    discussion!
                                                        .data!
                                                        .items![item]
                                                        .discussionLocation!
                                                        .lng!
                                                        .toDouble(),
                                                  ) /
                                                  1000,
                                            )).toString() +
                                            " KM",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  double lat = discussion!.data!.items![item]
                                      .discussionLocation!.lat!;
                                  double lng = discussion!.data!.items![item]
                                      .discussionLocation!.lng!;
                                  MapsLauncher.launchCoordinates(lat, lng);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.map,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Buka di Google Maps',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
          markerdis.add(missingMarkers);
          markerdisInMap.add(missingMarkersLargeMap);
        }
        marker.addAll(markerdis);
        markerInMap.addAll(markerdisInMap);
      }

      myState = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        e.response!.statusCode;
        if (e.response!.statusMessage == "invalid or expired jwt" ||
            e.response!.statusMessage == "missing or malformed jwt") {
          AuthViewModel().removeToken();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const WelcomePage(),
          ));
        }
      }
    }
    notifyListeners();
  }

  Future fetchDiscussionOnMark(
      BuildContext context, String discussionID) async {
    try {
      stateInMark = MyState.loading;
      notifyListeners();

      discussionOnMark =
          await service.getDetailDiscussion(context, discussionID);
      if (myDiscussion!.message == "invalid or expired jwt" ||
          discussion!.message == "missing or malformed jwt") {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ));
      }
      stateInMark = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        e.response!.statusCode;
        if (e.response!.statusMessage == "invalid or expired jwt" ||
            e.response!.statusMessage == "missing or malformed jwt") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const WelcomePage(),
          ));
        }
      }

      print(e);
      print("code : ${e}");
      stateInMark = MyState.failed;
      notifyListeners();
    }
  }

  Future fetchMyDiscussion(BuildContext context) async {
    try {
      myState2 = MyState.loading;
      notifyListeners();

      myDiscussion = await service.getMyDiscussion(context);

      if (myDiscussion!.message == "invalid or expired jwt" ||
          myDiscussion!.message == "missing or malformed jwt") {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ));
      
      }

      myState2 = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        if (e.response != null &&
            (e.response!.statusCode == 401 || e.response!.statusCode == 403)) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const WelcomePage(),
          ));
       
        }
      }
    }

    notifyListeners();
  }

  Future fetchOneDiscussion(BuildContext context, String discussionID) async {
    try {
      mystate3 = MyState.loading;
      notifyListeners();

      discussionDetail =
          await service.getDetailDiscussion(context, discussionID);
      if (myDiscussion!.message == "invalid or expired jwt" ||
          discussion!.message == "missing or malformed jwt") {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        ));
      }

      mystate3 = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        e.response!.statusCode;
        if (e.response!.statusMessage == "invalid or expired jwt" ||
            e.response!.statusMessage == "missing or malformed jwt") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const WelcomePage(),
          ));
        }

        mystate3 = MyState.failed;
      }

      print(e);
      print("code : ${e}");
      notifyListeners();
    }
  }

  Future likeDiscussion(BuildContext context, String discussionID) async {
    try {
      myState = MyState.loading;
      myState2 = MyState.loading;
      notifyListeners();

      final String isLike =
          await service.postLikeDiscussion(context, discussionID);
      if (myDiscussion!.message == "invalid or expired jwt" ||
          discussion!.message == "missing or malformed jwt") {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
      }
      myState = MyState.loaded;
      myState2 = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        e.response!.statusCode;
        if (e.response!.statusMessage == "invalid or expired jwt" ||
            e.response!.statusMessage == "missing or malformed jwt") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
        }
      }

      print(e);
      print("code : ${e}");
      myState = MyState.failed;
      myState2 = MyState.failed;
      notifyListeners();
    }
  }

  Future delDiscussion(BuildContext context, String discussionID) async {
    try {
      myState = MyState.loading;
      myState2 = MyState.loading;
      notifyListeners();

      final String isDelete =
          await service.delDiscussion(context, discussionID);
      if (myDiscussion!.message == "invalid or expired jwt" ||
          discussion!.message == "missing or malformed jwt") {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
      }
      myState = MyState.loaded;
      myState2 = MyState.loaded;
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        e.response!.statusCode;
        if (e.response!.statusMessage == "invalid or expired jwt" ||
            e.response!.statusMessage == "missing or malformed jwt") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
        }
      }

      print(e);
      print("code : ${e}");
      myState = MyState.failed;
      myState2 = MyState.failed;
      notifyListeners();
    }
  }
}
