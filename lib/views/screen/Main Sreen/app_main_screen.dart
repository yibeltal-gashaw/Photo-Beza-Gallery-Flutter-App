import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_beza_gallery/views/screen/Home/pages/home_screen.dart';
import 'package:photo_beza_gallery/views/screen/profile/profile_screen.dart';
import 'package:photo_beza_gallery/views/screen/search/search_screen.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({Key? key}) : super(key: key);

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _currentIndex = 0;
  String? userPhone; // Store fetched phone number
  bool _isLoading = true; // Track loading state
  late List<Widget> _pages; // Declare pages list

  // Fetch the current user's phone number
  Future<void> fetchCurrentUserPhoneNumber() async {
    try {
      final user = FirebaseAuth.instance.currentUser; // Get logged-in user
      if (user == null) {
        print("User is not logged in");
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Fetch by UID
          .get();

      if (userDoc.exists) {
        setState(() {
          userPhone = userDoc.data()?['phone'] ?? 'No phone number found';
          _isLoading = false; // Stop loading
          _pages = [
            HomeScreen(phone: userPhone!),
            SearchScreen(phone: userPhone!),
            const ProfileScreen(),
          ];
        });
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching phone number: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      const Center(child: CircularProgressIndicator()), // Placeholder during loading
      const Center(child: CircularProgressIndicator()),
      const ProfileScreen(),
    ];
    fetchCurrentUserPhoneNumber(); // Fetch phone number when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : _pages[_currentIndex], // Show pages when data is ready
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black38,
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Iconsax.search_normal), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
