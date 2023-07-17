import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sipencari_app/models/missing/discussion_model.dart';
import 'package:sipencari_app/service/providers/comment/comment_provider.dart';
import 'package:sipencari_app/service/providers/discussion/discussion_provider.dart';
import 'package:sipencari_app/service/providers/location_provider.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/util/finite_state.dart';
import 'package:timeago/timeago.dart' as timeago;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  late PageController _pageController;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();
  void initState() {
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
    Future.delayed(Duration.zero, () {
      timeago.setLocaleMessages('id', timeago.IdMessages());
      final _providerLocaiton =
          Provider.of<LocationProvider>(context, listen: false);
      _providerLocaiton.initUserPosition(context);
      final _providerdiscussion =
          Provider.of<DiscussionProvider>(context, listen: false);
      _markers = _providerdiscussion.markerInMap;
      final _providerComment =
          Provider.of<CommentProvider>(context, listen: false);

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
    _providerDiscussoin.fetchDiscussion("100000", "0", context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  static const LatLng sourceLocation = LatLng(-6.378444, 106.984133);
  static const LatLng destination = LatLng(-6.378444, 106.984133);

  @override
  Widget build(BuildContext context) {
    double heightt = MediaQuery.of(context).size.height;
    double widthh = MediaQuery.of(context).size.width;

  

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
                    "KEHILANGAN DI MAP",
                    style: mediumTextStyle,
                  ),
                  IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      _markers.removeAll(_markers.where(
                        (marker) => marker.markerId.value == "markingmissing",
                      ));
                      final _providerLocaiton =
                          Provider.of<LocationProvider>(context, listen: false);
                      _providerLocaiton.initUserPosition(context);
                      final _providerDiscussoin =
                          Provider.of<DiscussionProvider>(context,
                              listen: false);
                      _providerDiscussoin.fetchDiscussion(
                          "100000", "0", context);
                    },
                  )
                ],
              ),
            ),
          )),
      body: Consumer2<LocationProvider, DiscussionProvider>(
        builder: (context, value, value2, child) {
          switch (value.myState) {
            case MyState.loading:
              return Center(child: CircularProgressIndicator());
            case MyState.loaded:
              if (value.ltdLng == null) {
                return GoogleMap(
                  onMapCreated: (controller) {},
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(_markers),
                  myLocationButtonEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          value2
                              .discussionDetail!.data!.discussionLocation!.lat!
                              .toDouble(),
                          value2
                              .discussionDetail!.data!.discussionLocation!.lng!
                              .toDouble()),
                      zoom: 11),
                 
                );
              } else {
                return GoogleMap(
                  onMapCreated: (controller) {},
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(_markers),
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                        value.ltdLng!.latitude.toDouble(),
                        value.ltdLng!.longitude.toDouble(),
                      ),
                      zoom: 14),
                  
                );
              }
            case MyState.failed:
              return Center(
                child: Text("cannot load map"),
              );
            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
