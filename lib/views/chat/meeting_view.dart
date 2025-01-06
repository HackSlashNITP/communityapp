import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:communityapp/controllers/meeting_controller.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VideoCallScreen extends StatefulWidget {
  final String username;
  VideoCallScreen({required this.username});
  @override

  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoCallController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Meeting room : ${controller.channelName}"),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // Video Grid
          Obx(() => GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: controller.users.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Stack(
                  children: [
                    AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: controller.engine,
                        canvas: VideoCanvas(uid: 0),
                      ),
                    ),

                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Text(
                        'You',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                final userId = controller.users[index - 1];
                return Stack(
                  children: [
                    AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: controller.engine,
                        canvas: VideoCanvas(uid: userId),
                        connection: RtcConnection(channelId: controller.channelName.value),
                      ),
                    ),

                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Text(
                        "$userId",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          )),

          // Control buttons (Mute, Video, Leave)
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: controller.toggleMute,
                  icon: Icon(controller.isMuted.value ? Icons.mic_off : Icons.mic),
                ),
                IconButton(
                  onPressed: controller.toggleVideo,
                  icon: Icon(controller.isVideoEnabled.value ? Icons.videocam : Icons.videocam_off),
                ),
                IconButton(
                  onPressed: controller.leaveChannel,
                  icon: Icon(Icons.call_end, color: Colors.red),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}