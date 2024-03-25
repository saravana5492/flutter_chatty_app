import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

bool isValidMobile(String value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(patttern);
  if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (err) {
    if (context.mounted) {
      showSnackBar(context: context, content: err.toString());
    }
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (err) {
    if (context.mounted) {
      showSnackBar(context: context, content: err.toString());
    }
  }
  return video;
}

//: check for cache
Future<FileInfo?> checkCacheFor(String url) async {
  final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
  return value;
}

//:cached Url Data
void cachedForUrl(String url) async {
  await DefaultCacheManager().getSingleFile(url).then((value) {
    print('downloaded successfully done for $url');
  });
}
