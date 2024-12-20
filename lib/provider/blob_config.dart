import 'package:flutter/cupertino.dart';

class BlobConfig {
  final String blobUrl;

  BlobConfig({required this.blobUrl});

  Uri getUri(String api) {
    String url = '$blobUrl/$api';
    debugPrint(url);
    return Uri.parse(url);
  }
}