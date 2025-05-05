import 'package:flutter/material.dart';
import 'package:photo_beza_gallery/constant/constant.dart';

class ImageCard extends StatelessWidget {
  final String url;
  final String phone;
  final String status;

  const ImageCard({
    Key? key,
    required this.url,
    required this.phone,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            // Image Section
            Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width * 0.93,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
                image: DecorationImage(
                  image: NetworkImage(imageUrl+url),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // Handle image loading errors
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
