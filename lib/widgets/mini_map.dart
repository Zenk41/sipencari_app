import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sipencari_app/widgets/button.dart';

class MiniMap extends StatelessWidget {
  const MiniMap(
      {super.key,
      required this.cameraPosition,
      required this.mapType,
      required this.mapPaddingGeo,
      required this.buttonMap,
      this.markerMissing,
      this.completeMap});
  final CameraPosition cameraPosition;
  final MapType mapType;
  final EdgeInsets mapPaddingGeo;
  final Button buttonMap;
  final Set<Marker>? markerMissing;
  final Function(GoogleMapController)? completeMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              child: GoogleMap(
                onMapCreated: completeMap,
                initialCameraPosition: cameraPosition,
                mapType: mapType,
                padding: mapPaddingGeo,
                // zoomControlsEnabled: false,
                myLocationEnabled: true,
                markers: markerMissing!,
              ),
            ),
            Container(
              child: buttonMap,
            ),
          ],
        ),
      ),
    );
  }
}
