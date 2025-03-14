
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
  final RxnInt selectedUid = RxnInt(null);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoCallController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Meeting Room: ${controller.channelName}", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor:  Color(0xff110E2B),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ Color(0xff110E2B),  Color(0xff110E2B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [

            Obx(() {
              if (selectedUid.value != null) {
                return _buildZoomedView(selectedUid.value!, controller);
              } else {
                return _buildGridView(controller);
              }
            }),

            // Control buttons
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: controller.isMuted.value ? Icons.mic_off : Icons.mic,
                    color: controller.isMuted.value ? Colors.redAccent : Colors.green,
                    onTap: controller.toggleMute,
                  ),
                  _buildControlButton(
                    icon: controller.isVideoEnabled.value ? Icons.videocam : Icons.videocam_off,
                    color: controller.isVideoEnabled.value ? Colors.blue : Colors.redAccent,
                    onTap: controller.toggleVideo,
                  ),
                  _buildControlButton(
                    icon: Icons.call_end,
                    color: Colors.red,
                    onTap: controller.leaveChannel,
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildGridView(VideoCallController controller) {
    int userCount = controller.users.length + 1;
    int crossAxisCount = userCount <= 2 ? 1 : (userCount <= 4 ? 2 : 3);

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: userCount <= 2 ? 1.5 : 1,
      ),
      itemCount: userCount,
      itemBuilder: (context, index) {
        int uid = index == 0 ? 0 : controller.users[index - 1];
        return GestureDetector(
          onTap: () => selectedUid.value = uid, // Tap to zoom
          child: _buildVideoTile(uid: uid, controller: controller),
        );
      },
    );
  }


  Widget _buildZoomedView(int uid, VideoCallController controller) {
    return GestureDetector(
      onTap: () => selectedUid.value = null,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white54, width: 2),
            color: Colors.black,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: _buildVideoTile(uid: uid, controller: controller, isZoomed: true),
          ),
        ),
      ),
    );
  }


  Widget _buildVideoTile({required int uid, required VideoCallController controller, bool isZoomed = false}) {
    bool isUser = uid == 0;

    return Obx(() {
      bool isVideoEnabled = isUser ? controller.isVideoEnabled.value : controller.remoteVideoStates[uid] ?? true;

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white54, width: 2),
          color: Colors.black,

        ),
        child: isVideoEnabled
            ? ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AgoraVideoView(
            controller: isUser
                ? VideoViewController(
              rtcEngine: controller.engine,
              canvas: VideoCanvas(uid: uid),
            )
                : VideoViewController.remote(
              rtcEngine: controller.engine,
              canvas: VideoCanvas(uid: uid),
              connection: RtcConnection(channelId: controller.channelName.value),
            ),
          ),
        )
            : Center(
          child: Icon(Icons.videocam_off, color: Colors.white54, size: isZoomed ? 80 : 50),
        ),
      );
    });
  }

  Widget _buildControlButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: color,
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
