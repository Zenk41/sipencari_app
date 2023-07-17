import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sipencari_app/shared/shared.dart';

class FullImage extends StatefulWidget {
  final String imageUrl;
  final String title;

  FullImage({required this.imageUrl, required this.title});

  @override
  State<FullImage> createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: _isDownloading
                ? CircularProgressIndicator()
                : Icon(Icons.download),
            color: Colors.black,
            onPressed: _isDownloading
                ? null
                : () {
                    _downloadImage(widget.imageUrl);
                  },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: PhotoView(
              backgroundDecoration: BoxDecoration(color: whiteColor),
              imageProvider: CachedNetworkImageProvider(widget.imageUrl),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2.0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadImage(String imageUrl) async {
    setState(() {
      _isDownloading = true;
    });

    try {
      var downloadsDir = await DownloadsPathProvider.downloadsDirectory;

      var fileName = imageUrl.split('/').last;
      var filePath = '${downloadsDir?.path}/$fileName';

      await DefaultCacheManager().downloadFile(imageUrl, key: imageUrl);

      var cachedImageFile = await DefaultCacheManager().getSingleFile(imageUrl);
      var imageBytes = await cachedImageFile.readAsBytes();

      await File(filePath).writeAsBytes(imageBytes);

      print("Download successful. Path: $filePath");
      Fluttertoast.showToast(
        msg: 'Image downloaded successfully. Path: $filePath"',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: primaryColor,
        textColor: whiteColor,
      );
    } catch (error) {
      print("Download failed: $error");
    }

    setState(() {
      _isDownloading = false;
    });
  }
}

class DownloadsPathProvider {
  static Future<Directory?> get downloadsDirectory async {
    Directory? downloadsDir;

    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    return downloadsDir;
  }
}
