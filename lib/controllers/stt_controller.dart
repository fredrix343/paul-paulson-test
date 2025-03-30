import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_speech/google_speech.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../methods/open_ai_methods.dart';
import '../models/message.dart';

class STTController extends GetxController {
  RxBool isDarkMode = false.obs;
  TextEditingController controller = TextEditingController();
  final RxBool isRecording = false.obs;
  final RxString recognizedText = ''.obs;
  final RxBool isLoading = false.obs;
  final record = AudioRecorder();
  late SpeechToText speechToText;
  final RxList<Message> messages = <Message>[].obs;
  final OpenAIService openAIService = OpenAIService();
  final Rx<Duration> recordingDuration = Duration.zero.obs;
  Timer? _timer;
  final RxBool isRecordbutton = false.obs;
  final RxBool isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initSpeechClient();
  }

  Future<void> _initSpeechClient() async {
    final credentialsJson = await rootBundle.loadString(
      'assets/credentials.json',
    );
    final serviceAccount = ServiceAccount.fromString(credentialsJson);
    speechToText = SpeechToText.viaServiceAccount(serviceAccount);
  }

  Future<String> _getFilePath() async {
    final dir = await getTemporaryDirectory();
    return p.join(dir.path, 'recorded.wav');
  }

  Future<void> startRecording() async {
    final path = await _getFilePath();

    if (await record.hasPermission()) {
      await record.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: path,
      );
      isRecording.value = true;
      recordingDuration.value = Duration.zero;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        recordingDuration.value += Duration(seconds: 1);
      });
    }
  }

  Future<void> stopRecordingAndTranscribe() async {
    final path = await record.stop();
    isRecording.value = false;
    _timer?.cancel();

    // Add loading message to UI
    final loadingMessage = Message(
      isUser: true,
      messageString: 'transcribing...',
      messageType: "text",
      isLoading: true,
    );

    messages.add(loadingMessage);
    update();

    if (path != null) {
      final audioBytes = await File(path).readAsBytes();

      final config = RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        sampleRateHertz: 16000,
        languageCode: 'en-US',
      );

      final response = await speechToText.recognize(config, audioBytes);

      final transcript = response.results
          .map((e) => e.alternatives.first.transcript)
          .join('\n');

      recognizedText.value = transcript;

      // Replace the last message (loading) with actual transcribed message
      final lastIndex = messages.length - 1;
      isRecordbutton.value = false;

      messages[lastIndex] = Message(
        isUser: true,
        messageString: transcript,
        messageType: "text",
        isLoading: false,
      );

      update();
      processUserInput(transcript);
    }
  }

  Future<void> textInputResponse() async {
    try {
      final newMessage = Message(
        isUser: true,
        messageString: controller.text.trim(),
        messageType: 'text',
      );
      messages.add(newMessage);
      processUserInput(controller.text.trim());
      print("Sending: ${controller.text}");
      controller.clear();
    } catch (e) {}
  }

  Future<void> processUserInput(String userInput) async {
    // Add user's message to the chat
    // messages.add(
    //   Message(isUser: true, messageString: userInput, messageType: 'text'),
    // );

    // Show a loading message from the bot
    final loadingMessage = Message(
      isUser: false,
      messageString: 'Thinking...',
      messageType: 'text',
    );
    messages.add(loadingMessage);

    // Fetch response from ChatGPT
    try {
      final botResponse = await openAIService.getChatbotResponse(userInput);
      print(botResponse);
      messages.remove(loadingMessage); // Remove loading message
      messages.add(
        Message(isUser: false, messageString: botResponse, messageType: 'text'),
      );
      recordingDuration.value = Duration.zero;
    } catch (e) {
      print(e);
      messages.remove(loadingMessage); // Remove loading message
      messages.add(
        Message(
          isUser: false,
          messageString: 'Failed to get response. Please try again.',
          messageType: 'text',
        ),
      );
    }

    update(); // Notify UI to update
  }
}
