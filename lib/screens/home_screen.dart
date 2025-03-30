import 'package:aiappmaster/controllers/stt_controller.dart';
import 'package:aiappmaster/controllers/tts_controller.dart';
import 'package:aiappmaster/screens/tts_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/icon_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  STTController con = Get.put(STTController());
  TTSController c = Get.put(TTSController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor:
            con.isDarkMode.value ? Color(0xff151e2b) : Colors.white,
        bottomNavigationBar: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: c.isAudio.value ? _buildAudioBottomBar() : _buildBottomBar(),
          // child: _buildBottomBar(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),

              child: Column(children: [_buildTopBar(), TTSHomePage()]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return AnimatedContainer(
      padding: EdgeInsets.symmetric(horizontal: 10),
      duration: Duration(milliseconds: 300),
      height: 70,
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
            size: 35,
            color: con.isDarkMode.value ? Colors.white : Colors.black,
          ),
          InkWell(
            onTap: () => con.isDarkMode.toggle(),
            child: IconWidget(
              assetName: con.isDarkMode.value ? 'sun.png' : "night.png",
              size: 35,
              color: con.isDarkMode.value ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Obx(
      () => AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child:
            con.isRecordbutton.value
                ? AnimatedContainer(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  duration: Duration(milliseconds: 300),
                  height: 140,
                  decoration: BoxDecoration(
                    color:
                        con.isDarkMode.value ? Color(0xff1c2d40) : Colors.white,
                    // border:
                    //     c.isTTS.value
                    //         ? Border.all(color: Color(0xff243342), width: 2)
                    //         : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
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
                                height: 60,
                                duration: Duration(milliseconds: 300),
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
                      ),
                      Positioned(
                        top: 0 - 20,
                        right: 0 - 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () => con.isRecordbutton.toggle(),
                            icon: Icon(Icons.close),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : AnimatedContainer(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  duration: Duration(milliseconds: 300),
                  height: 110,
                  decoration: BoxDecoration(
                    color:
                        con.isDarkMode.value ? Color(0xff1c2d40) : Colors.white,
                    // border:
                    //     c.isTTS.value
                    //         ? Border.all(color: Color(0xff243342), width: 2)
                    //         : null,
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
                          onChanged: (val) {
                            con.isTyping.value = true;
                            // setState(() => isTyping = val.trim().isNotEmpty);
                          },
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
                        key: ValueKey("send"),
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          con.textInputResponse();
                        },
                      ),
                      IconButton(
                        key: ValueKey("mic"),
                        icon: Icon(Icons.mic, color: Colors.red),
                        onPressed: () => con.isRecordbutton.value = true,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildAudioBottomBar() {
    return Obx(
      () => AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
            // Duration Row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    await c.audioPlayer.stop(); // Stop any playing audio
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

            // Progress Bar
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

            // Controls Row
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
      // : const SizedBox.shrink(),
    );
  }

  Widget _circleButton(String icon, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.all(12),

        child: IconWidget(assetName: icon, size: 32, color: Colors.white),
      ),
    );
  }
}
