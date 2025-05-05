import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:photo_beza_gallery/controller/app_image_provider.dart';
import 'package:photo_beza_gallery/firebase_options.dart';
import 'package:photo_beza_gallery/views/screen/Auth/pages/login_view.dart';
import 'package:photo_beza_gallery/views/screen/Main%20Sreen/app_main_screen.dart';
import 'package:photo_beza_gallery/views/screen/welcome/pages/landing_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';


Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppImageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Routing Example',
        home: InitialScreen(),
      ),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  Future<String> determineStartPage() async {
  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool('isFirstTime') ?? true;
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  if (isFirstTime) {
    // Set isFirstTime to false only if routing to the landing page
    prefs.setBool('isFirstTime', false);
    return 'landing';
  } else if (isLoggedIn) {
    return 'mainpage';
  } else {
    return 'login';
  }
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: determineStartPage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          switch (snapshot.data) {
            case 'landing':
              return LandingPage();
            case 'mainpage':
              return AppMainScreen();
            default:
              return LoginView();
          }
        } else {
          return Center(child: Text('Error loading app'));
        }
      },
    );
  }
}