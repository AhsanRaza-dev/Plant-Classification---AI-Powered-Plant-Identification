// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_app/controllers/color_controller.dart';
import 'package:plant_app/view/get_started/get_started.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize color scheme controller
  final colorController = Get.put(ColorSchemeController());

  // Load saved color scheme
  await colorController.loadColorSchemePreference();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorSchemeController colorController = Get.find();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: colorController.getThemeData(
          colorController.currentColorScheme.value,
        ),
        home: const GetStartedPage(),
      ),
    );
  }
}
