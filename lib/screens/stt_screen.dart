import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stt_controller.dart';

class STTScreen extends StatelessWidget {
  final STTController controller = Get.put(STTController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google STT (Record → Transcribe)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(
              () => TextField(
                controller: TextEditingController(
                  text: controller.recognizedText.value,
                ),
                maxLines: null,
                readOnly: true,
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Transcription",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Obx(
              () => ElevatedButton.icon(
                icon: Icon(
                  controller.isRecording.value ? Icons.stop : Icons.mic,
                ),
                label: Text(
                  controller.isRecording.value
                      ? 'Stop & Transcribe'
                      : 'Start Recording',
                ),
                onPressed:
                    controller.isRecording.value
                        ? controller.stopRecordingAndTranscribe
                        : controller.startRecording,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor:
                      controller.isRecording.value ? Colors.red : Colors.green,
                ),
              ),
            ),
            Obx(
              () =>
                  controller.isLoading.value
                      ? CircularProgressIndicator()
                      : Text("Transcribed"),
            ),
            Text("transcription: ${controller.recognizedText.value}"),
          ],
        ),
      ),
    );
  }
}
