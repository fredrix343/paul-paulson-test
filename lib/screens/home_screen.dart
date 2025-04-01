import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aiappmaster/controllers/stt_controller.dart';
import 'package:aiappmaster/controllers/tts_controller.dart';
import 'package:aiappmaster/screens/tts_screen.dart';
import 'widgets/icon_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  STTController con = Get.put(STTController());
  TTSController c = Get.put(TTSController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Scroll to bottom when a new message is added
    ever(con.messages, (_) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Obx(
          () => Scaffold(
            backgroundColor:
                con.isDarkMode.value ? Color(0xff151e2b) : Colors.white,
            bottomSheet: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child:
                  c.isAudio.value
                      ? _buildAudioBottomBar(constraints)
                      : _buildBottomBar(constraints),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  left: constraints.maxWidth * 0.05,
                  right: constraints.maxWidth * 0.05,
                  bottom:
                      c.isAudio.value
                          ? constraints.maxHeight * 0.12
                          : constraints.maxHeight * 0.06,
                ),
                child: Column(
                  children: [_buildTopBar(constraints), TTSHomePage()],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BoxConstraints constraints) {
    return AnimatedContainer(
      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.03),
      duration: Duration(milliseconds: 300),
      height: constraints.maxHeight * 0.09,
      decoration: BoxDecoration(
        color: con.isDarkMode.value ? Color(0xff1c2d40) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border:
            con.isDarkMode.value
                ? Border.all(color: Color(0xff243342), width: 2)
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconWidget(
            assetName: 'menu.png',
            size: constraints.maxWidth * 0.08,
            color: con.isDarkMode.value ? Colors.white : Colors.black,
          ),
          InkWell(
            onTap: () => con.isDarkMode.toggle(),
            child: IconWidget(
              assetName: con.isDarkMode.value ? 'sun.png' : "night.png",
              size: constraints.maxWidth * 0.08,
              color: con.isDarkMode.value ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BoxConstraints constraints) {
    return Obx(
      () => AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child:
            con.isRecordbutton.value
                ? ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: 1,
                    child: AnimatedSize(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.05,
                          vertical: constraints.maxHeight * 0.02,
                        ),
                        height: constraints.maxHeight * 0.18,
                        decoration: BoxDecoration(
                          color:
                              con.isDarkMode.value
                                  ? Color(0xff1c2d40)
                                  : Colors.white,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(0.3),
                          //     spreadRadius: 2,
                          //     blurRadius: 6,
                          //     offset: Offset(0, 3),
                          //   ),
                          // ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${con.recordingDuration.value.inMinutes.toString().padLeft(2, '0')}:${(con.recordingDuration.value.inSeconds % 60).toString().padLeft(2, '0')}",
                                  style: TextStyle(
                                    color:
                                        con.isDarkMode.value
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap:
                                      con.isRecording.value
                                          ? con.stopRecordingAndTranscribe
                                          : con.startRecording,
                                  child: AnimatedContainer(
                                    height: constraints.maxHeight * 0.08,
                                    duration: Duration(milliseconds: 400),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          con.isRecording.value
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                    child: Center(
                                      child: Text(
                                        con.isRecording.value
                                            ? "Recording"
                                            : "Record",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: -10,
                              right: -10,
                              child: IconButton(
                                onPressed: () => con.isRecordbutton.toggle(),
                                icon: Icon(Icons.close),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                : AnimatedContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.05,
                    vertical: constraints.maxHeight * 0.02,
                  ),
                  duration: Duration(milliseconds: 300),
                  // height: constraints.maxHeight * 0.1,
                  decoration: BoxDecoration(
                    color:
                        con.isDarkMode.value ? Color(0xff1c2d40) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLines: null,
                          controller: con.controller,
                          onChanged: (val) => con.isTyping.value = true,
                          decoration: InputDecoration(
                            hintText: "Type your message...",
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: () => con.textInputResponse(),
                      ),
                      IconButton(
                        icon: Icon(Icons.mic, color: Colors.red),
                        onPressed: () => con.isRecordbutton.value = true,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildAudioBottomBar(BoxConstraints constraints) {
    return Obx(
      () => AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth * 0.05,
          vertical: constraints.maxHeight * 0.015,
        ),
        decoration: BoxDecoration(
          color: con.isDarkMode.value ? const Color(0xff1c2d40) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    await c.audioPlayer.stop();
                    c.isPlaying.value = false;
                    c.isAudio.value = false;
                    c.duration.value = Duration.zero;
                    c.position.value = Duration.zero;
                    c.currentText.value = "";
                  },
                  child: Icon(Icons.close),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  c.formatDuration(c.position.value),
                  style: TextStyle(
                    color: con.isDarkMode.value ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  c.formatDuration(c.duration.value),
                  style: TextStyle(
                    color: con.isDarkMode.value ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value:
                  c.duration.value.inMilliseconds == 0
                      ? 0
                      : c.position.value.inMilliseconds /
                          c.duration.value.inMilliseconds,
              backgroundColor:
                  con.isDarkMode.value ? Colors.white24 : Colors.black45,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 4,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.replay_10,
                    color: con.isDarkMode.value ? Colors.white : Colors.black,
                  ),
                  onPressed: c.rewind,
                ),
                IconButton(
                  icon: Icon(
                    c.isPlaying.value ? Icons.pause : Icons.play_arrow,
                    color: con.isDarkMode.value ? Colors.white : Colors.black,
                    size: 30,
                  ),
                  onPressed: c.togglePlay,
                ),
                IconButton(
                  icon: Icon(
                    Icons.forward_10,
                    color: con.isDarkMode.value ? Colors.white : Colors.black,
                  ),
                  onPressed: c.forward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
