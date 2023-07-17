import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sipencari_app/models/missing/discussion_model.dart';
import 'package:sipencari_app/page/detail/missing_detail.dart';
import 'package:sipencari_app/page/home_page/map.dart';
import 'package:sipencari_app/page/home_page/tips1.dart';
import 'package:sipencari_app/page/home_page/tips2.dart';
import 'package:sipencari_app/service/providers/discussion/discussion_provider.dart';
import 'package:sipencari_app/service/providers/location_provider.dart';
import 'package:sipencari_app/service/providers/profile/profile_provider.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/util/category.dart';
import 'package:sipencari_app/util/finite_state.dart';
import 'package:sipencari_app/widgets/button.dart';
import 'package:sipencari_app/widgets/mini_map.dart';
import 'package:sipencari_app/widgets/mini_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  late PageController _pageController;
  Completer<GoogleMapController> _controller = Completer();
  int activePage = 1;
  Set<Marker> markerMissing = {};
  List<DiscussionData>? disData;
  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
    Future.delayed(Duration.zero, () {
      final _providerProfile =
          Provider.of<ProfileProvider>(context, listen: false);
      _providerProfile.fetchProfil(context);
      final _providerLocaiton =
          Provider.of<LocationProvider>(context, listen: false);
      _providerLocaiton.initUserPosition(context);
      final _providerDiscussion =
          Provider.of<DiscussionProvider>(context, listen: false);
      _providerDiscussion.fetchDiscussion("10000", "0", context);
    });

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _asynchMethod();
  }

  void _asynchMethod() async {
    markerMissing.removeAll(markerMissing.where(
      (marker) => marker.markerId.value == "markingmissing",
    ));
    final _providerDiscussion =
        Provider.of<DiscussionProvider>(context, listen: false);
    setState(() {
      markerMissing = _providerDiscussion.marker;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    _asynchMethod();
    double heightQ = MediaQuery.of(context).size.height;
    double widthQ = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Consumer2<ProfileProvider, LocationProvider>(
          builder: (context, provider1, provider2, _) {
            switch (provider1.myState) {
              case MyState.loading:
                return Center(child: CircularProgressIndicator());
              case MyState.loaded:
                if (provider1.profil!.data!.picture.toString() == "") {
                  return Center(
                    child: SafeArea(
                        child: MiniProfile(
                      name: provider1.profil!.data!.name.toString().length > 15
                          ? provider1.profil!.data!.name
                                  .toString()
                                  .substring(0, 15) +
                              '...'
                          : provider1.profil!.data!.name.toString(),
                      location: provider2.initAddress!.length > 27
                          ? provider2.initAddress!.substring(0, 27) + '...'
                          : provider2.initAddress,
                      urlImage:
                          "https://sipencari.s3.ap-southeast-3.amazonaws.com/deffault/deffault_profile.png",
                      iconInBar: () {
                        Future.delayed(Duration.zero, () {
                          final _providerDiscussion =
                              Provider.of<DiscussionProvider>(context,
                                  listen: false);
                          _providerDiscussion.fetchDiscussion(
                              "5", "0", context);
                        });
                      },
                    )),
                  );
                } else if (provider2.initAddress == "") {
                  return Center(
                    child: SafeArea(
                        child: MiniProfile(
                      name: provider1.profil!.data!.name.toString().length > 15
                          ? provider1.profil!.data!.name
                                  .toString()
                                  .substring(0, 15) +
                              '...'
                          : provider1.profil!.data!.name.toString(),
                      location: "Cannot load Location",
                      urlImage: provider1.profil!.data!.picture.toString(),
                      iconInBar: () {
                        Future.delayed(Duration.zero, () {
                          final _providerDiscussion =
                              Provider.of<DiscussionProvider>(context,
                                  listen: false);
                          _providerDiscussion.fetchDiscussion(
                              "5", "0", context);
                          setState(() {
                            markerMissing.addAll(_providerDiscussion.markerdis);
                          });
                        });
                      },
                    )),
                  );
                } else {
                  return Center(
                    child: SafeArea(
                        child: MiniProfile(
                      name: provider1.profil!.data!.name.toString().length > 15
                          ? provider1.profil!.data!.name
                                  .toString()
                                  .substring(0, 15) +
                              '...'
                          : provider1.profil!.data!.name.toString(),
                      location: provider2.initAddress!.length > 27
                          ? provider2.initAddress!.substring(0, 27) + '...'
                          : provider2.initAddress,
                      urlImage: provider1.profil!.data!.picture.toString(),
                      iconInBar: () {
                        Future.delayed(Duration.zero, () {
                          final _providerDiscussion =
                              Provider.of<DiscussionProvider>(context,
                                  listen: false);
                          _providerDiscussion.fetchDiscussion(
                              "5", "0", context);
                        });
                      },
                    )),
                  );
                }
              case MyState.failed:
                return Center(
                  child: SafeArea(
                      child: MiniProfile(
                    name: "Load Name",
                    location: "Load Location",
                    urlImage:
                        "https://sipencari.s3.ap-southeast-3.amazonaws.com/deffault/deffault_profile.png",
                  )),
                );

              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
      body: SizedBox(
        height: heightQ,
        width: widthQ,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: heightQ * 26 / 800,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "Kehilangan di sekitar mu",
                    style: mediumTextStyle,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Consumer2<LocationProvider, DiscussionProvider>(
                    builder: (context, provider, provider2, child) {
                      switch (provider2.myState) {
                        case MyState.loading:
                          return Center(child: CircularProgressIndicator());
                        case MyState.loaded:
                          if (provider.ltdLng == null) {
                            return MiniMap(
                                completeMap: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                                markerMissing: markerMissing,
                                cameraPosition: CameraPosition(
                                    target: LatLng(-6.379613, 106.980363),
                                    zoom: 15),
                                mapType: MapType.normal,
                                mapPaddingGeo: EdgeInsets.all(5),
                                buttonMap: Button(
                                  bRadius: BorderRadius.circular(10),
                                  color: primaryColor,
                                  centerText: Text("Lihat"),
                                  onPress: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => MapPage())));
                                  },
                                ));
                          } else {
                            return MiniMap(
                                cameraPosition: CameraPosition(
                                    target: provider.ltdLng!, zoom: 15),
                                mapType: MapType.normal,
                                mapPaddingGeo: EdgeInsets.all(5),
                                markerMissing: markerMissing,
                                buttonMap: Button(
                                  bRadius: BorderRadius.circular(10),
                                  color: primaryColor,
                                  centerText: Text("Lihat"),
                                  onPress: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => MapPage())));
                                  },
                                ));
                          }
                        case MyState.failed:
                          return MiniMap(
                              cameraPosition: CameraPosition(
                                  target: LatLng(-6.379613, 106.980363),
                                  zoom: 15),
                              mapType: MapType.normal,
                              mapPaddingGeo: EdgeInsets.all(5),
                              buttonMap: Button(
                                bRadius: BorderRadius.circular(10),
                                color: primaryColor,
                                centerText: Text("Lihat"),
                                onPress: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => MapPage())));
                                },
                              ));
                        default:
                          return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: heightQ * 26 / 800,
                ),
                Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Postingan Kehilangan",
                              style: mediumTextStyle,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 200,
                          child:
                              Consumer2<DiscussionProvider, LocationProvider>(
                            builder: (context, value1, value2, child) {
                              switch (value1.myState) {
                                case MyState.loading:
                                  return CircularProgressIndicator();
                                case MyState.loaded:
                                  if (value1.discussion!.data!.items![0].title
                                          .toString() ==
                                      "") {
                                    return Text("Belum ada data");
                                  } else if (value2.initPosition == null) {
                                    return Center(
                                      child: Column(
                                        children: [
                                          Text("Tidak bisa memuat data"),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      primaryColor),
                                              onPressed: () async {
                                                value2
                                                    .initUserPosition(context);
                                              },
                                              child: Text(
                                                  "Klik untuk mengaktifkan lokasi"))
                                        ],
                                      ),
                                    );
                                  } else {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: value1
                                            .discussion!.data!.items!.length,
                                        itemBuilder: ((context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: ((context) =>
                                                            MissingDetail(
                                                              missingID: value1
                                                                  .discussion!
                                                                  .data!
                                                                  .items![index]
                                                                  .discussionId
                                                                  .toString(),
                                                            ))));
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    color: whiteColor,
                                                  ),
                                                  width: 170,
                                                  padding: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Expanded(
                                                          child: Stack(
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl:
                                                                "${value1.discussion!.data!.items![index].discussionPictures![0].url}",
                                                            fit: BoxFit.cover,
                                                      
                                                            alignment: Alignment
                                                                .center,
                                                          ),
                                                          Positioned(
                                                            top: 0,
                                                            left: 0,
                                                            right: 0,
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          16),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              child: Text(
                                                                getCategoryTranslation(value1
                                                                        .discussion!
                                                                        .data!
                                                                        .items![
                                                                            index]
                                                                        .category
                                                                        .toString()) +
                                                                    " Hilang",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${value1.discussion!.data!.items![index].title}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: smallTextStyle
                                                                  .copyWith(
                                                                      fontSize:
                                                                          9,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              maxLines: 1,
                                                              softWrap: false,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              "${value1.discussion!.data!.items![index].discussionLocation!.locationName}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: smallTextStyle
                                                                  .copyWith(
                                                                      fontSize:
                                                                          7),
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              maxLines: 1,
                                                              softWrap: false,
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              (NumberFormat.compactCurrency(decimalDigits: 2, symbol: '', locale: 'id_IN').format(Geolocator.distanceBetween(
                                                                              value2.initPosition!.latitude,
                                                                              value2.initPosition!.longitude,
                                                                              value1.discussion!.data!.items![index].discussionLocation!.lat!.toDouble(),
                                                                              value1.discussion!.data!.items![index].discussionLocation!.lng!.toDouble()) /
                                                                          1000))
                                                                      .toString() +
                                                                  " KM",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              maxLines: 1,
                                                              softWrap: false,
                                                              style: smallTextStyle
                                                                  .copyWith(
                                                                      fontSize:
                                                                          10),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          );
                                        }));
                                  }
                                case MyState.failed:
                                  return Text("Belum ada data");
                                default:
                                  return CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: heightQ * 26 / 800,
                ),
                Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Lainnya",
                            style: mediumTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      Container(
                        child: Column(
                          children: [
                            Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Tips1()),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        size: 24.0,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 8.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 8.0),
                                            Text(
                                              "Tips & Trick menemukan Kehilangan",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 8.0),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Tips2()),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.security,
                                        size: 24.0,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 8.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 8.0),
                                            Text(
                                              "Tips & Trick menyimpan barang dengan aman",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 8.0),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
