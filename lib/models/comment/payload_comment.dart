import 'package:image_picker/image_picker.dart';

class CommentModel {
  final String message;
  final List<XFile>? comment_pictures;
  CommentModel({
    required this.message,
    this.comment_pictures,
  });
}
