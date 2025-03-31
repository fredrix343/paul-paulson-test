import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:path_provider/path_provider.dart';

class TTSService {
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

  bool _isInitialized = false;
  late VoiceGoogle _selectedVoice;
  var apikey = "YOUR-KEY-HERE";

  Future<void> initTTS({required String apiKey}) async {
    if (_isInitialized) return;

    // Initialize with API key
    TtsGoogle.init(params: InitParamsGoogle(apiKey: apiKey), withLogs: true);

    // Get voices
    final voicesResponse = await TtsGoogle.getVoices();
    final voices = voicesResponse.voices;

    // Pick first English voice
    _selectedVoice =
        voices.where((element) => element.locale.code.startsWith("en-")).first;

    _isInitialized = true;
  }

  Future<File> textToSpeech(String text) async {
    if (!_isInitialized) {
      throw Exception('TTS not initialized. Call initTTS() first.');
    }

    final ttsParams = TtsParamsGoogle(
      voice: _selectedVoice,
      audioFormat: AudioOutputFormatGoogle.mp3,
      text: text,
      rate: 'slow',
      pitch: 'default',
    );

    final ttsResponse = await TtsGoogle.convertTts(ttsParams);
    final audioBytes = ttsResponse.audio.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/tts_output.mp3';
    final audioFile = File(filePath);
    await audioFile.writeAsBytes(audioBytes);

    return audioFile;
  }
}
