import 'package:aiappmaster/screens/home_screen.dart';
import 'package:aiappmaster/screens/stt_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'screens/tts_screen.dart';

// 1. Go to Google Cloud Console
// 🔗 https://console.cloud.google.com

// 2. Create or select a project
// In the top-left dropdown, either:
// Select an existing project
// Or click "New Project"

// 3.Enable the necessary APIs
// Enable these two:  Cloud Text-to-Speech API + Cloud Speech-to-Text API

//4. Create a Service Account
// Go to: https://console.cloud.google.com/iam-admin/serviceaccounts
// Click "Create Service Account"
// Give it a name like: tts-stt-service
// Click "Create and Continue"
// Under Role, select:
// Project → Editor (or just Cloud Text-to-Speech User + Cloud Speech-to-Text User)
// Click Done

//Open AI API Key
//1.Login into Open AI
//2.Add payment details, set quota.
//3.Generate API key

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}
