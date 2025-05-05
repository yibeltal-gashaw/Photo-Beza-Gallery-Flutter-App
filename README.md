# Photo Beza Gallery

A modern Flutter application for managing and viewing photo galleries with cloud storage integration.

## Features

- 📸 Photo gallery management
- ☁️ Cloud storage integration with Cloudinary
- 🔐 Firebase authentication
- 📱 Cross-platform support (Android, iOS, Web, Windows, Linux, macOS)
- 🖼️ Photo viewing with zoom capabilities
- 🔄 Offline caching support
- 🎨 Modern UI with custom fonts and animations

## Prerequisites

- Flutter SDK (>=2.12.0)
- Dart SDK (>=2.12.0)
- Firebase account
- Cloudinary account

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yibeltal-gashaw/Photo-Beza-Gallery-Flutter-App.git
```

2. Navigate to the project directory:
```bash
cd Photo_Beza_Gallery_Flutter_App
```

3. Install dependencies:
```bash
flutter pub get
```

4. Configure Firebase:
   - Add your Firebase configuration files
   - Set up Firebase Authentication
   - Configure Cloud Firestore

5. Configure Cloudinary:
   - Add your Cloudinary credentials
   - Set up the appropriate cloud storage settings

## Running the App

To run the app in debug mode:
```bash
flutter run
```

For release builds:
```bash
flutter build [platform] --release
```

## Dependencies

- `provider`: State management
- `firebase_core`: Firebase integration
- `cloud_firestore`: Cloud database
- `firebase_auth`: Authentication
- `cloudinary_sdk`: Cloud storage
- `image_picker`: Image selection
- `photo_view`: Image viewing
- `cached_network_image`: Image caching
- `shared_preferences`: Local storage
- `toastification`: Toast notifications
- `animated_text_kit`: Text animations
- `iconsax`: Custom icons

## Project Structure

```
lib/
├── main.dart
├── screens/
├── widgets/
├── models/
├── services/
├── providers/
└── utils/
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue in the GitHub repository or contact the maintainers.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Cloudinary for cloud storage
- All contributors and maintainers
