import 'package:image_picker/image_picker.dart';

class DiscussionModel1 {
  final String title;
  final String content;
  final String category;
  final List<XFile>? discussion_pictures;
  final String status;
  final String privacy;
  DiscussionModel1(
      {required this.title,
      required this.content,
      required this.category,
      this.discussion_pictures,
      required this.status,
      required this.privacy});
}

class DiscussionModel2 {
  final String lat;
  final String lng;
  DiscussionModel2({
    required this.lat,
    required this.lng,
  });
}

class DiscussionModel {
  final String title;
  final String content;
  final String lat;
  final String lng;
  final String category;
  final String status;
  final String privacy;
  DiscussionModel(
      {required this.lat,
      required this.lng,
      required this.title,
      required this.content,
      required this.category,
      required this.status,
      required this.privacy});
}
