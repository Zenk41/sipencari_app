import 'package:flutter/material.dart';
import 'package:sipencari_app/shared/shared.dart';

class CardMissing extends StatelessWidget {
  CardMissing(
      {super.key, required this.distance, required this.image, required this.locationName, required this.title});
  String image;
  String title;
  String locationName;
  String distance;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: whiteColor,
        ),
        width: 170,
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              image,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: smallTextStyle.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    locationName,
                    textAlign: TextAlign.left,
                    style: smallTextStyle.copyWith(fontSize: 10),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    distance,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: smallTextStyle.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
