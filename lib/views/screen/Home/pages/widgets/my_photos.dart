import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_beza_gallery/components/show_error.dart';
import 'package:toastification/toastification.dart';
class MyPhotos extends StatelessWidget {
  final String imagePath;
  final String status;
  final String ocassion;
  final double? left;
  final double? width;
  final bool? overflow;
  final VoidCallback? onTap;
  const MyPhotos({
    Key? key, 
    required this.imagePath, 
    required this.status,
    required this.ocassion,
    this.onTap, this.left = 120,this.width = 300, this.overflow = false}) : super(key: key);

    Future<void> downloadImage(String imageUrl) async {
    try {
      final dio = Dio();
      // Manually specify the path to the Downloads directory
      final directory = '/storage/emulated/0/Download';
      final filePath = '$directory/${imageUrl.split('/').last}';

      await dio.download(imageUrl, filePath);
      print(filePath);

      showToast(ToastificationType.success, "Image downloaded successfully");
    } catch (e) {
      showToast(ToastificationType.error, "Failed to download image");
    }
  }

  @override
  Widget build(BuildContext context) {

    return 
        Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: status == "unpaid" ? 
                  Opacity(
                    opacity: 0.2, // Adjust the opacity (0.0 to 1.0)
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      width: width,
                    ),
                  ):Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      width: width,
                    ),
                ),
                status == "unpaid" ?Positioned(
                  left: left,
                  top: 90,
                  child: Center(
                  child: Icon(Iconsax.lock, size: 40,),
                )): Center(),
              ],)
              ),
            overflow == true ? overflowContainer():Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 10.0),
            child: Row(
                children: [
                  Text(
                     ocassion == "gena"?"የልደት ፎቶ"
                    :ocassion =="timket"?"የጥምቀት ፎቶ"
                    :ocassion =="fasika"?"የትንሳኤ  ፎቶ"
                    :ocassion =="awetawi"?"የአመታዊ ጉባኤ ፎቶ"
                    :ocassion =="graduation"?"የምርቃት ፎቶ"
                    :"",
                    overflow: TextOverflow.fade,
                    style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold, fontFamily: "washera"),
                  ),
                  SizedBox(width: 150.0,),
                  GestureDetector(
                    onTap: () => status == "unpaid" ? null : downloadImage(imagePath),
                  child: Icon(Iconsax.document_download, color: status == "unpaid"?Colors.grey: Colors.blue,size: 30.0,))
                ],
              ),
            ),
          ],
        ),
      );
  }

  Padding overflowContainer() {
    return Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 10.0, bottom: 10.0),
            child: Row(
              children: [
                Expanded( // Prevents overflow
                  child: Text(
                      ocassion == "gena" ? "የልደት ፎቶ"
                    : ocassion == "timket" ? "የጥምቀት ፎቶ"
                    : ocassion == "fasika" ? "የትንሳኤ ፎቶ"
                    : ocassion == "awetawi" ? "የአመታዊ ጉባኤ ፎቶ"
                    : ocassion == "graduation" ? "የምርቃት ፎቶ"
                    : "",
                    overflow: TextOverflow.ellipsis, // Adds "..." if text is too long
                    maxLines: 1, // Ensures it stays in one line
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontFamily: "washera",
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Provides spacing
                GestureDetector(
                  onTap: status == "unpaid" ? null : () => downloadImage(imagePath),
                  child: Icon(
                    Iconsax.document_download,
                    color: status == "unpaid" ? Colors.grey : Colors.blue,
                    size: 30,
                  ),
                ),
              ],
            )

          );
  }
}

