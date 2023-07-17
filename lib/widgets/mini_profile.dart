import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sipencari_app/shared/shared.dart';

class MiniProfile extends StatelessWidget {
  const MiniProfile(
      {super.key,
      this.urlImage =
          'https://sipencari.s3.ap-southeast-3.amazonaws.com/deffault/deffault_profile.png',
      this.name,
      this.location,
      this.iconInBar});
  final String? urlImage;
  final String? name;
  final String? location;
  final Function()? iconInBar;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Image border
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(30), // Image radius
                      child: CachedNetworkImage(
                          imageUrl: urlImage!, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello, $name",
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          style:
                              smallTextStyle.copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Flexible(
                        child: Text(
                          location!,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.left,
                          style: smallTextStyle.copyWith(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: iconInBar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
