import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String appId = "8e86aebaf39b4fe5a5ffddac88d668a1";

class VideoCallController extends GetxController {
  late RtcEngine engine;
  final users = <int>[].obs;
  final isMuted = false.obs;
  final isVideoEnabled = true.obs;
  final rtcToken = ''.obs;
  final channelName = ''.obs;
  final int uid = Random().nextInt(90000) + 10000;

  @override
  void onInit() {
    super.onInit();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    await [Permission.microphone, Permission.camera].request();
    if (await Permission.microphone.isGranted && await Permission.camera.isGranted) {
      try {
        engine = await createAgoraRtcEngine();
        await engine.initialize(
          RtcEngineContext(
            appId: appId,
            channelProfile: ChannelProfileType.channelProfileCommunication,
          ),
        );

        engine.registerEventHandler(
          RtcEngineEventHandler(
            onJoinChannelSuccess: (connection, elapsed) {
              print("Joined channel: ${connection.channelId}");
            },
            onUserJoined: (connection, remoteUid, elapsed) {
              users.add(remoteUid);
            },
            onUserOffline: (connection, remoteUid, reason) {
              users.remove(remoteUid);
            },
          ),
        );

        await engine.enableVideo();
        await engine.startPreview();
      } catch (e) {
        print("Error initializing Agora engine: $e");
        Get.snackbar("Error", "Failed to initialize Agora engine.");
      }
    } else {
      Get.snackbar("Permission Error", "Please grant microphone and camera permissions.");
    }
  }

  Future<void> fetchTokenAndJoinChannel(String channelName) async {
    try {
      final response = await http.get(Uri.parse(
        "https://agora-token-server-ijb9.onrender.com/rtc/$channelName/publisher/uid/$uid",
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["rtcToken"] != null && data["rtcToken"].isNotEmpty) {
          rtcToken.value = data["rtcToken"];
          await joinChannel(channelName);
        } else {
          Get.snackbar("Error", "Token is invalid or empty.");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch token. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching token: $e");
      Get.snackbar("Error", "An error occurred while fetching the token.");
    }
  }


  Future<void> joinChannel(String channelName) async {
    this.channelName.value = channelName;

    if (engine == null) {
      Get.snackbar("Error", "Agora engine is not initialized.");
      return;
    }

    // Check if the RTC token is available and valid
    if (rtcToken.value.isNotEmpty) {
      try {

        print("RTC Token: ${rtcToken.value}");


        await engine.joinChannel(
          token: rtcToken.value,
          channelId: channelName,
          uid: uid,
          options: const ChannelMediaOptions(
            publishCameraTrack: true,
            publishMicrophoneTrack: true,
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
            autoSubscribeVideo: true,
            autoSubscribeAudio: true,
          ),
        );
      } catch (e) {
        print("Error joining channel: $e");
        Get.snackbar("Error", "An error occurred while joining the channel. Please try again.");
      }
    }
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    engine.muteLocalAudioStream(isMuted.value);
  }

  void toggleVideo() {
    isVideoEnabled.value = !isVideoEnabled.value;
    engine.muteLocalVideoStream(!isVideoEnabled.value);
  }

  Future<void> leaveChannel() async {
    try {
      await engine.leaveChannel();
      users.clear();
      Get.back();
    } catch (e) {
      print("Error leaving channel: $e");
      Get.snackbar("Error", "An error occurred while leaving the channel.");
    }
  }
}
