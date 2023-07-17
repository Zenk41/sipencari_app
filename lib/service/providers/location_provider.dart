import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sipencari_app/shared/shared.dart';
import 'package:sipencari_app/util/finite_state.dart';
import 'package:sipencari_app/widgets/button.dart';

class LocationProvider extends ChangeNotifier {
  Position? initPosition;
  String? initAddress;
  LatLng? ltdLng;

  LocationPermission? permission;
  MyState myState = MyState.loading;

  Future initUserPosition(BuildContext context) async {
    try {
      myState = MyState.loading;
      notifyListeners();

      await getPermission(context).catchError((e) {
        print(e);
        getPermission(context);
      });

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude,localeIdentifier: 'id');

      initPosition = position;

      initAddress =
          '${placemarks[0].subLocality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].postalCode}';
      print("test lat ${initPosition!.latitude}");
      print("test lat ${initPosition!.longitude}");
      LatLng ltdLngs =
          await LatLng(initPosition!.latitude, initPosition!.longitude);

      ltdLng = ltdLngs;
      myState = MyState.loaded;
      notifyListeners();
    } catch (e) {
      print(e);
      myState = MyState.failed;
      notifyListeners();
    }
  }

  Future getPermission(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await reqPermissionDialog(context);
      }
    } else {
      await reqPermissionDialog(context);
    }

    return;
  }

  Future reqPermissionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Akses Lokasi',
              style: mediumTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'In order to continue, please allow the app to gain location access on your device',
                textAlign: TextAlign.center,
                style: mediumTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 18),
              Container(
                height: 44,
                child: Button(
                  bRadius: BorderRadius.circular(16),
                  color: primaryColor,
                  centerText: Text("Allow or Open Setting"),
                  onPress: () async {
                    if (permission == LocationPermission.denied ||
                        permission == LocationPermission.deniedForever) {
                      await openAppSettings();
                    }
                    permission = await Geolocator.requestPermission();

                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
