import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sipencari_app/models/missing/data_discussion_model.dart';
import 'package:sipencari_app/page/main_page/add_missing.dart';
import 'package:sipencari_app/service/providers/discussion/discussion_provider.dart';
import 'package:sipencari_app/service/providers/location_provider.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/util/finite_state.dart';
import 'package:sipencari_app/util/image.dart';
import 'package:sipencari_app/view_model/missing/missing_view_model.dart';
import 'package:sipencari_app/widgets/button.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  Set<Marker> _markers = Set();
  LatLng? _latLng;
  Placemark? place;
  BitmapDescriptor? markerIcon;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final _providerLocaiton =
          Provider.of<LocationProvider>(context, listen: false);
      _providerLocaiton.initUserPosition(context);
      final _providerdiscussion =
          Provider.of<DiscussionProvider>(context, listen: false);
      _markers = _providerdiscussion.marker;
      _markers.remove(_markers.where(
        (marker) => marker.markerId.value == "markingmissing",
      ));
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
    markerIcon = await getBitmapDescriptorFromAssetBytes(
        "assets/icons/marker_pick.png", 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                    ),
                    color: blackColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "PILIH LOKASI KEHILANGAN",
                    style: mediumTextStyle,
                  ),
                  Container(
                    width: 30,
                  )
                ],
              ),
            ),
          )),
      body: Container(
        color: whiteColor,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  height: 350,
                  child: Consumer<LocationProvider>(
                    builder: (context, value, child) {
                      switch (value.myState) {
                        case MyState.loading:
                          return Center(child: CircularProgressIndicator());
                        case MyState.loaded:
                          if (value.ltdLng == null) {
                            return GoogleMap(
                                myLocationEnabled: true,
                                mapType: MapType.normal,
                                markers: Set<Marker>.of(_markers),
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(value.ltdLng!.latitude,
                                        value.ltdLng!.longitude),
                                    zoom: 11),
                    
                                onTap: (latLng) async {
                                  _latLng = latLng;
                                  List<Placemark> placemarks =
                                      await placemarkFromCoordinates(
                                          latLng.latitude, latLng.longitude);
                                  place = placemarks[0];
                                  _markers.add(Marker(
                                      markerId: MarkerId('markingmissing'),
                                      position: latLng));
                                });
                          } else {
                            return GoogleMap(
                                myLocationEnabled: true,
                                mapType: MapType.normal,
                                markers: Set<Marker>.of(_markers),
                                initialCameraPosition:
                                    CameraPosition(target: value.ltdLng!, zoom: 14),
                              
                                onTap: (latLng) async {
                                  _latLng = latLng;
                                  List<Placemark> placemarks =
                                      await placemarkFromCoordinates(
                                          latLng.latitude, latLng.longitude);
                                  place = placemarks[0];
                                  _markers.add(Marker(
                                      icon: markerIcon!,
                                      markerId: MarkerId('markingmissing'),
                                      position: latLng));
                                  setState(() {});
                                });
                          }
                        case MyState.failed:
                          return Center(
                            child: Text("tidak bisa memuat map"),
                          );
                        default:
                          return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("latitude ${_latLng?.latitude}"),
                    SizedBox(
                      height: 10,
                    ),
                    Text("longtitude ${_latLng?.longitude}"),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Alamat: \n${place}",
                      textAlign: TextAlign.left,
                    ),
                  ]),
            ),
            Align(
              child: Button(
                color: primaryColor,
                centerText: Text("Selanjutnya"),
                bRadius: BorderRadius.circular(10),
                onPress: () {
                  if (_latLng != null) {
                    final latltd = DiscussionModel2(
                        lat: _latLng!.latitude.toString(),
                        lng: _latLng!.longitude.toString());
                    Provider.of<MissingViewModel>(context, listen: false)
                        .saveData2(latltd);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => AddMissing(
                                  disModel2: latltd,
                                ))));
                  } else {
                    Fluttertoast.showToast(
                        msg: "Click or pick location to set location",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
