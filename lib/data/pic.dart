class Pic {
  /// Unique identifier of the picture.
  int id;

  /// title of the picture
  String title;

  /// Additional description of the picture
  String desc;

  /// The one who drew this pic.
  String author;

  /// The ID of the uploader
  int uploaderId;

  /// link to the pic
  String link;

  /// File size in bytes.
  int fileSize;

  /// image width
  int width;

  /// image height
  int height;

  ///image aspect ratio
  int aspectRatio;

  /// link to the preview image
  String previewLink;

  /// preview width
  int previewWidth;

  /// preview height
  int previewHeight;

  /// tags
  List<String> tags;
}
