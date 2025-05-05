import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_beza_gallery/constant/constant.dart';
import 'package:photo_beza_gallery/controller/app_image_provider.dart';
import 'package:photo_beza_gallery/views/screen/Home/pages/widgets/my_photos.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final String? occasion;
  final String? phone;

  const SearchScreen({Key? key, this.occasion, this.phone}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late AppImageProvider imagesProvider;
  List filteredImages = [];
  String selectedOccasion = '';
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;

  Future<void> fetchImages({String? status, String? occasion}) async {
    setState(() => isLoading = true);
    try {
      if (widget.phone != null) {
        await imagesProvider.fetchImagesByPhone(widget.phone!);
      }
      
      setState(() {
        filteredImages = imagesProvider.imagesList.where((image) {
          final matchesStatus = status == null || image.status == status;
          final matchesOccasion = occasion == null || image.ocassion == occasion;
          return matchesStatus && matchesOccasion;
        }).toList();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> downloadImage(String imageUrl) async {
    try {
      final dio = Dio();
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/${imageUrl.split('/').last}';
      await dio.download(imageUrl, filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image downloaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download image: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    imagesProvider = Provider.of<AppImageProvider>(context, listen: false);
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.phone != null) {
        await fetchImages();
      }
    });
  }

  Widget _buildOccasionGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredImages.length,
      itemBuilder: (context, index) {
        final image = filteredImages[index];
        return MyPhotos(
          imagePath: imageUrl + image.imageUrl, 
        status: image.status, 
        ocassion: image.ocassion,
        left: 55,
        width: double.infinity,
        overflow: true
        );
        
      },
    );
  }

   Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Iconsax.arrow_left_2)),
          Image.asset('assets/images/photo.png', height: 40, width: 40),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Align(
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'Search by status',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                    
                    suffixIcon: IconButton(
                      icon: const Icon(Iconsax.search_normal),
                      onPressed: () => fetchImages(status:_phoneController.text)
                    ),
                  ),
                  onChanged: (String status){
                    fetchImages(status: status);
                  },
                ),
              ),
            ),
          ),
          _buildShoppingBagIcon(),
        ],
      ),
    );
  }

  Widget _buildShoppingBagIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Iconsax.shopping_bag, size: 24),
        Positioned(
          top: -3,
          right: -3,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '1',
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOccasionFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
          'Filter by Occasion',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
          DropdownButton<String>(
            value: selectedOccasion.isEmpty ? null : selectedOccasion,
            items: const [
              DropdownMenuItem(value: 'gena', child: Text('የልደት ፎቶ')),
              DropdownMenuItem(value: 'timket', child: Text('የጥምቀት ፎቶ')),
              DropdownMenuItem(value: 'fasika', child: Text('የትንሳኤ ፎቶ')),
              DropdownMenuItem(value: 'awetawi', child: Text('የአመታዊ ጉባኤ ፎቶ')),
              DropdownMenuItem(value: 'graduation', child: Text('የምርቃት ፎቶ')),
            ],
            onChanged: (String? value) {
              if (value != null) {
                setState(() => selectedOccasion = value);
                fetchImages(occasion: value);
              }
            },
            hint: const Text("-- Filter by Occasion --"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              _buildOccasionFilter(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildOccasionGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
