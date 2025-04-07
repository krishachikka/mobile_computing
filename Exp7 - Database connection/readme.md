# Flutter Login App with Firebase

This project demonstrates how to build a simple login app using Flutter and Firebase. It integrates Firebase Core and Cloud Firestore to provide authentication and data storage functionalities.

## Project Setup

### Prerequisites
Before you get started, make sure you have the following installed on your system:
- Flutter SDK (Latest Stable Version)
- Firebase Project (configured in Firebase Console)
- Android Studio / VSCode (or any code editor of your choice)

### Dependencies

The following dependencies are used in this project:
- `flutter`: The Flutter SDK for building cross-platform applications.
- `firebase_core`: Used for initializing Firebase in your Flutter project.
- `cloud_firestore`: Provides access to Firestore for storing and retrieving user data.

### Steps to Configure Firebase

1. **Create Firebase Project**:
    - Go to [Firebase Console](https://console.firebase.google.com/), create a new project.
    - Follow the steps to add Firebase to your Flutter app (for both Android and iOS platforms).

2. **Add Firebase Dependencies**:
   Add the following dependencies to your `pubspec.yaml` file:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     firebase_core: ^latest_version
     cloud_firestore: ^latest_version
   ```

3. **Configure Firebase for Your Flutter Project**:
    - In your Firebase Console, configure your app with the necessary platforms (Android/iOS).
    - Download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) and place them in your Flutter project as per Firebase instructions.

4. **Generate Firebase Options**:
   Run the following command to configure Firebase in your Flutter app:
   ```bash
   flutterfire configure
   ```
   This will generate a `firebase_options.dart` file to set up Firebase with the required options.

5. **Ensure Firebase Initialization**:
   In your `main.dart` file, make sure Firebase is initialized before your app runs:

   ```dart
   import 'package:firebase_core/firebase_core.dart';
   import 'firebase_options.dart'; // Import generated options file

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform, // Initialize with options
     );
     runApp(MyApp());
   }
   ```

### Database Setup
This app uses **Cloud Firestore** to store user data (e.g., login credentials). Make sure you enable Firestore in the Firebase console and set the necessary security rules for your database.

---

## Project Structure

- **lib**: Contains the main app files (e.g., `main.dart`, login screen, Firebase logic).
- **firebase_options.dart**: Automatically generated file with Firebase configuration options for initialization.
- **android** / **ios**: Platform-specific code and configuration for Firebase.

---

## Firebase Authentication

If you're using Firebase Authentication, make sure to configure the appropriate authentication method in the Firebase Console (e.g., Email/Password, Google Sign-In, etc.). You can add the authentication logic based on your needs.

### Example Firestore Usage

To store user data after a successful login, you can use the following code:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUserData(String userId, String username) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).set({
    'username': username,
    'email': 'user@example.com',
  });
}
```

---

## Running the App

1. Clone this repository.
2. Make sure your Firebase project is properly configured (as described above).
3. Run the app on an emulator or a physical device.

```bash
flutter run
```

---

## Troubleshooting

- **Error: Firebase not initialized**: Ensure that you've correctly followed all the Firebase setup steps, including adding the `google-services.json` or `GoogleService-Info.plist` file and initializing Firebase.
- **Firestore permissions**: Ensure your Firestore security rules are set up correctly to allow reads and writes.

For more detailed documentation, refer to [Firebase for Flutter](https://firebase.flutter.dev/docs/overview).

---

Feel free to adjust the details as per your exact project setup!