import 'package:flutter/material.dart';
import 'package:photo_beza_gallery/components/app_bar.dart';
import 'package:photo_beza_gallery/components/horizontal_text.dart';
import 'package:photo_beza_gallery/constant/constant.dart';
import 'package:photo_beza_gallery/controller/app_image_provider.dart';
import 'package:photo_beza_gallery/views/screen/Home/pages/widgets/app_banner.dart';
import 'package:photo_beza_gallery/views/screen/Home/pages/widgets/my_photos.dart';
import 'package:photo_beza_gallery/views/screen/Home/pages/widgets/ocassion_card.dart';
import 'package:photo_beza_gallery/views/screen/search/search_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String phone;
  const HomeScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppImageProvider imagesProvider;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      imagesProvider = Provider.of<AppImageProvider>(context, listen: false);
      
      // Fetch images only if they haven't been loaded already.
      if (imagesProvider.imagesList.isEmpty && !imagesProvider.isLoading) {
        imagesProvider.fetchImagesByPhone(widget.phone);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            MyAppBar(),
            AppBanner(),
            HorizontalText(textleft: 'Photo by Ocassion', textright: "See all"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OcassionCard(
                    image: 'assets/images/lidet.png', 
                    title: 'ልደት',
                    ontap: () => Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (builder) => SearchScreen(occasion: "gena", phone: widget.phone))),
                  ),
                    
                  SizedBox(width: 15),
                  OcassionCard(
                    image: 'assets/images/timket.png', 
                    title: 'ጥምቀት',
                    ontap: () => Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (builder) => SearchScreen(occasion: "timket", phone: widget.phone))),),
                  SizedBox(width: 15),
                  OcassionCard(
                    image: 'assets/images/tinsae.png', 
                    title: 'ፋሲካ',
                    ontap: () => Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (builder) => SearchScreen(occasion: "fasika", phone: widget.phone))),),
                  SizedBox(width: 15),
                  OcassionCard(
                    image: 'assets/images/gubae.png', 
                    title: 'አመታዊ ጉባኤ',
                    ontap: () => Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (builder) => SearchScreen(occasion: "awetawi", phone: widget.phone))),),
                  OcassionCard(
                    image: 'assets/images/graduation.png', 
                    title: 'ምርቃት',
                    ontap: () => Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (builder) => SearchScreen(occasion: "graduation", phone: widget.phone))),),
                ],
              ),
            ),
            HorizontalText(textleft:'My photos', textright: 'See all'),
            Consumer<AppImageProvider>(
              builder: (context, imagesProvider, child) {
                if (imagesProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (imagesProvider.imagesList.isEmpty) {
                  return ClipRect(
                    child: Image.asset("assets/images/notfound.png"),
                  );
                } else {
                  return  SizedBox(
                      height: 280,
                      width:  MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: imagesProvider.imagesList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                         // print("Total uploaded paid images ${imagesProvider.imagesList}");
                         // imagesProvider.imagesList[index].status == "paid"?  
                           final image = imagesProvider.imagesList[index];
                           return  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:MyPhotos(
                              imagePath: imageUrl+ image.imageUrl,
                              status: image.status,
                              ocassion: image.ocassion,
                              ),
                          );
                        },
                      ),
                  );
                }
              },
            ),
         
          ],
        ),
      ),
    );
  }
}

