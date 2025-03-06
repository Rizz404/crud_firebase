import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saturday_firebase_project/features/biodata/screens/biodata_screen.dart';
import 'package:saturday_firebase_project/features/camera/screens/camera_screen.dart';
import 'package:saturday_firebase_project/features/mahasiswa/screens/mahasiswa_screen.dart';
import 'package:saturday_firebase_project/firebase_options.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Firebase & Camera",
      debugShowCheckedModeBanner: false,
      home: CameraScreen(),
    );
  }
}
