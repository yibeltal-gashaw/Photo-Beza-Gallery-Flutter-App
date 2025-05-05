import 'package:flutter/material.dart';
import 'package:photo_beza_gallery/constant/constant.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatelessWidget {
  final List<dynamic> images;
  final int initialIndex;

  const ImageViewer({Key? key, required this.images, required this.initialIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Image"),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: PhotoViewGallery.builder(
        itemCount: images.length,
        pageController: PageController(initialPage: initialIndex),
        builder: (context, index) {
          final image = images[index];
          final url = image['imageUrl'] ?? '';

          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrl + url),
            heroAttributes: PhotoViewHeroAttributes(tag: index),
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }
}
