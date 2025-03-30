import 'package:aiappmaster/screens/home_screen.dart';
import 'package:aiappmaster/screens/stt_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'screens/tts_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // TTSController c = Get.put(TTSController());

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}
